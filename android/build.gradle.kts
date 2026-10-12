allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.layout.buildDirectory.value(rootProject.layout.projectDirectory.dir("../build"))

subprojects {
    project.layout.buildDirectory.value(rootProject.layout.buildDirectory.dir(project.name).get())
    
    afterEvaluate {
        val android = project.extensions.findByName("android")
        if (android != null) {
            try {
                val testOptions = android.javaClass.getMethod("getTestOptions").invoke(android)
                val unitTests = testOptions.javaClass.getMethod("getUnitTests").invoke(testOptions)
                unitTests.javaClass.getMethod("setIncludeAndroidResources", Boolean::class.javaPrimitiveType).invoke(unitTests, false)
            } catch (e: Exception) {
                // Ignore or log
                println("Failed to override includeAndroidResources for ${project.name}: ${e.message}")
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
