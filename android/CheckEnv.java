public class CheckEnv {
    public static void main(String[] args) {
        String p = System.getenv("ANDROID_PREFS_ROOT");
        String u = System.getenv("ANDROID_USER_HOME");
        System.out.println("PREFS=[" + p + "]");
        System.out.println("USER_HOME=[" + u + "]");
        if (p != null && u != null) {
            System.out.println("Equals=" + p.equals(u));
        }
    }
}