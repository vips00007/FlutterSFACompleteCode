public class Check2 {
    public static void main(String[] args) {
        String p1 = System.getenv("ANDROID_PREFS_ROOT");
        String p2 = System.getenv("ANDROID_USER_HOME");
        System.out.println("p1 equals p2? " + p1.equals(p2));
        System.out.println("p1: " + p1);
        System.out.println("p2: " + p2);
        
        java.io.File f1 = new java.io.File(p1);
        java.io.File f2 = new java.io.File(p2);
        System.out.println("f1 == f2? " + f1.getAbsolutePath().equals(f2.getAbsolutePath()));
        System.out.println("f1 abs: " + f1.getAbsolutePath());
        System.out.println("f2 abs: " + f2.getAbsolutePath());
    }
}