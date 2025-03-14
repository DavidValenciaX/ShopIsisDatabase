-- Insertar tipos de interacciones de usuario con productos
INSERT INTO interaction_types (name, description) VALUES
('view', 'Usuario vio la página del producto'),
('search', 'Usuario encontró el producto a través de búsqueda'),
('add_to_cart', 'Usuario añadió el producto al carrito'),
('add_to_wishlist', 'Usuario añadió el producto a su lista de deseos'),
('purchase', 'Usuario compró el producto'),
('review', 'Usuario dejó una reseña del producto'),
('share', 'Usuario compartió el producto en redes sociales'),
('compare', 'Usuario añadió el producto a comparación'),
('question', 'Usuario hizo una pregunta sobre el producto'),
('return', 'Usuario devolvió el producto');