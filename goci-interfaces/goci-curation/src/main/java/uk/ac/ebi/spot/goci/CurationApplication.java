package uk.ac.ebi.spot.goci;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.web.SpringBootServletInitializer;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class CurationApplication extends SpringBootServletInitializer {
    public static void main(String[] args) {
        SpringApplication.run(CurationApplication.class, args);
    }
}
