package ma.projet.com.apigateway;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.reactive.CorsWebFilter;
import org.springframework.web.cors.reactive.UrlBasedCorsConfigurationSource;

import java.util.Collections;

@Configuration
public class GatewayCorsConfig {

    @Bean
    public CorsWebFilter corsWebFilter() {
        CorsConfiguration corsConfiguration = new CorsConfiguration();

        // Autoriser toutes les origines
        corsConfiguration.setAllowedOrigins(Collections.singletonList("*"));

        // Autoriser toutes les méthodes HTTP
        corsConfiguration.setAllowedMethods(Collections.singletonList("*"));

        // Autoriser tous les headers
        corsConfiguration.setAllowedHeaders(Collections.singletonList("*"));

        // Appliquer la configuration à tous les chemins
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", corsConfiguration);

        return new CorsWebFilter(source);
    }
}
