INSERT INTO stores (id, name, postal, city, country, address, latitude, longitude) VALUES
                                                                                       (1, 'Store One', 1010, 'Vienna', 'Austria', 'Schönbrunner Schlossstraße 47', 48.1850, 16.3120),
                                                                                       (2, 'Store Two', 3151, 'St. Georgen am Steinfelde', 'Austria', 'Schubertstraße 37', 48.134110, 15.617876),
                                                                                       (3, 'Store Three', 8020, 'Graz', 'Austria', 'Kaiser-Josef-Platz 1', 47.0702, 15.4395);

INSERT INTO saleproducts (id, ean, qr, name, discount, prize, store_id) VALUES
                                                                            (1, '1234567890123', 'QR123456789', 'Product A', 20, 10.99, 1),
                                                                            (2, '2345678901234', 'QR234567890', 'Product B', 15, 15.49, 1),
                                                                            (3, '3456789012345', 'QR345678901', 'Product C', 25, 5.99, 2),
                                                                            (4, '4567890123456', 'QR456789012', 'Product D', 10, 8.99, 3),
                                                                            (5, '5678901234567', 'QR567890123', 'Product E', 30, 12.99, 3);
