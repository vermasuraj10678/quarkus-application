package com.example;

import io.quarkus.test.junit.QuarkusTest;
import org.junit.jupiter.api.Test;

import static io.restassured.RestAssured.given;
import static org.hamcrest.CoreMatchers.containsString;

@QuarkusTest
public class GreetingResourceTest {

    @Test
    public void testHelloEndpoint() {
        given()
          .when().get("/greeting")
          .then()
             .statusCode(200)
             .body(containsString("Hello"));
    }

    @Test
    public void testInfoEndpoint() {
        given()
          .when().get("/greeting/info")
          .then()
             .statusCode(200)
             .body(containsString("quarkus-demo"));
    }
}
