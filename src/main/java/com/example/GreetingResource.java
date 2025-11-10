package com.example;

import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import org.eclipse.microprofile.config.inject.ConfigProperty;

@Path("/greeting")
public class GreetingResource {

    @ConfigProperty(name = "greeting.message", defaultValue = "Hello from Quarkus!")
    String message;

    @ConfigProperty(name = "app.environment", defaultValue = "unknown")
    String environment;

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public String hello() {
        return message;
    }

    @GET
    @Path("/info")
    @Produces(MediaType.APPLICATION_JSON)
    public AppInfo info() {
        return new AppInfo(
            "quarkus-demo",
            "1.0.0",
            environment,
            message
        );
    }

    public static class AppInfo {
        public String name;
        public String version;
        public String environment;
        public String greeting;

        public AppInfo(String name, String version, String environment, String greeting) {
            this.name = name;
            this.version = version;
            this.environment = environment;
            this.greeting = greeting;
        }
    }
}
