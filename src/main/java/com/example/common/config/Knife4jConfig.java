package com.example.common.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class Knife4jConfig {

    @Bean
    public OpenAPI travelPlatformOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("Travel Platform API")
                        .description("景区门票预订平台接口文档")
                        .version("1.0.0")
                        .contact(new Contact().name("travel-platform")));
    }
}
