public class Check4 {
    public static void main(String[] args) {
        System.out.println(System.getenv().getClass().getName());
        try {
            java.lang.reflect.Field f = System.getenv().getClass().getDeclaredField("m");
            System.out.println("Found field 'm'");
        } catch (Exception e) {
            e.printStackTrace();
            try {
                java.lang.reflect.Field[] fields = System.getenv().getClass().getDeclaredFields();
                for (java.lang.reflect.Field field : fields) {
                    System.out.println(field.getName());
                }
            } catch (Exception e2) {}
        }
    }
}