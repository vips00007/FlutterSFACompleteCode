public class Check3 {
    public static void main(String[] args) {
        System.out.println("ANDROID_PREFS_ROOT: " + System.getenv("ANDROID_PREFS_ROOT"));
        System.out.println("ANDROID_USER_HOME: " + System.getenv("ANDROID_USER_HOME"));
        System.out.println("ANDROID_SDK_HOME: " + System.getenv("ANDROID_SDK_HOME"));
        System.out.println("android.prefs.root: " + System.getProperty("android.prefs.root"));
        System.out.println("android.user.home: " + System.getProperty("android.user.home"));
    }
}