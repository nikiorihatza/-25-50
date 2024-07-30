package com.minus.spring.service;

import com.minus.spring.domain.Store;
import com.minus.spring.persistence.StoreRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class StoreService {

    @Autowired
    private StoreRepository storeRepository;

    @Autowired
    private RestTemplate restTemplate;

    @Value("${opencage.api.key}")
    private String apiKey;

    public List<Store> getSortedStoresByNearest(String currentLocation, double limit) {
        double[] currentCoords = geocode(currentLocation);

        List<Store> stores = storeRepository.findAll();
        return stores.stream()
                .sorted((s1, s2) -> Double.compare(
                        distance(currentCoords[0], currentCoords[1], s1.getLatitude(), s1.getLongitude()),
                        distance(currentCoords[0], currentCoords[1], s2.getLatitude(), s2.getLongitude())))
                .filter(store -> distance(currentCoords[0], currentCoords[1], store.getLatitude(), store.getLongitude()) <= limit)
                .collect(Collectors.toList());
    }

    private double[] geocode(String location) { // Location Format: Street Nr., Postal City, Country
        String url = "https://api.opencagedata.com/geocode/v1/json?q=" + URLEncoder.encode(location, StandardCharsets.UTF_8) + "&key=" + apiKey;
        try {
            String response = restTemplate.getForObject(url, String.class);
            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(response);
            JsonNode locationNode = root.path("results").get(0).path("geometry");
            double lat = locationNode.path("lat").asDouble();
            double lng = locationNode.path("lng").asDouble();
            return new double[]{lat, lng};
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to geocode location: " + location);
        }
    }

    private double distance(double lat1, double lon1, double lat2, double lon2) {
        final int R = 6371;
        double latDistance = Math.toRadians(lat2 - lat1);
        double lonDistance = Math.toRadians(lon2 - lon1);
        double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(lonDistance / 2) * Math.sin(lonDistance / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return R * c;
    }

    public Store saveStore(Store store) {
        double[] coords = geocode(store.getFullAddress());
        store.setLatitude(coords[0]);
        store.setLongitude(coords[1]);
        return storeRepository.save(store);
    }
}
