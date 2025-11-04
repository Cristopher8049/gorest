package utils;

import io.github.cdimascio.dotenv.Dotenv;

public class DotEnvReader {
    private static Dotenv dotenv;

    public static String get(String key) {
        if (dotenv == null) {
            dotenv = Dotenv.load();
        }
        return dotenv.get(key);
    }
}