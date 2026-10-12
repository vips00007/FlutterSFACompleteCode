public class Check {
    public static void main(String[] args) {
        String p1 = System.getenv("ANDROID_PREFS_ROOT");
        String p2 = System.getenv("ANDROID_USER_HOME");
        System.out.println("p1 length: " + (p1 == null ? "null" : p1.length()));
        System.out.println("p2 length: " + (p2 == null ? "null" : p2.length()));
        System.out.println("p1 equals p2? " + (p1 != null && p1.equals(p2)));
    }
}