-- Migración 002: Tabla de reseñas de usuarios
-- Un usuario puede tener una sola reseña por película

CREATE TABLE user_reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    movie_id INTEGER NOT NULL,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    content TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, movie_id)
);

CREATE TRIGGER update_user_reviews_modtime
    BEFORE UPDATE ON user_reviews
    FOR EACH ROW
    EXECUTE PROCEDURE update_modified_column();
