package utils;

import java.util.Random;

public class DataGenerator {

    private static final String[] FIRST_NAMES = {"John", "Jane", "Michael", "Emily", "William", "Sophia", "James", "Olivia", "David", "Ava"};
    private static final String[] LAST_NAMES = {"Smith", "Jones", "Williams", "Brown", "Davis", "Miller", "Wilson", "Moore", "Taylor", "Anderson"};
    private static final String[] DOMAINS = {"example.com", "testmail.com", "company.org", "mailservice.net"};
    private static final Random RANDOM = new Random();

    /**
     * Generates a random full name (first name + last name).
     * @return A randomly generated full name.
     */
    public static String generateRandomFullName() {
        String firstName = FIRST_NAMES[RANDOM.nextInt(FIRST_NAMES.length)];
        String lastName = LAST_NAMES[RANDOM.nextInt(LAST_NAMES.length)];
        return firstName + " " + lastName;
    }

    /**
     * Generates a random email based on a given name.
     * It sanitizes the name to create a valid email prefix.
     * @param name The name to base the email on.
     * @return A randomly generated email address.
     */
    public static String generateRandomEmail(String name) {
        String sanitizedName = name.toLowerCase().replaceAll("[^a-z0-9]", ""); // Remove non-alphanumeric chars
        String domain = DOMAINS[RANDOM.nextInt(DOMAINS.length)];
        int randomNumber = 1000 + RANDOM.nextInt(9000); // 4-digit random number
        return sanitizedName + randomNumber + "@" + domain;
    }

    // You can add more utility methods here if needed, for example:
    // public int generateRandomNumber(int min, int max) { ... }
    // public String generateRandomString(int length) { ... }
}