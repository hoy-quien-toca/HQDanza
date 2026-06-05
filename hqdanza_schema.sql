-- 1. Tabla de Eventos
CREATE TABLE events (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    band_name TEXT NOT NULL,
    description TEXT,
    date DATE NOT NULL,
    time TIME NOT NULL,
    venue TEXT NOT NULL,
    address TEXT,
    city TEXT NOT NULL,
    department TEXT NOT NULL,
    genre TEXT NOT NULL,
    age_rating TEXT DEFAULT 'ATP',
    price_type TEXT DEFAULT 'range', -- 'range', 'free', 'gorra', 'sobre'
    price_min INTEGER,
    price_max INTEGER,
    ticket_type TEXT DEFAULT 'link', -- 'link', 'whatsapp'
    ticket_contact TEXT,
    flyer_url TEXT,
    is_approved BOOLEAN DEFAULT FALSE,
    is_featured BOOLEAN DEFAULT FALSE,
    is_sold_out BOOLEAN DEFAULT FALSE,
    is_suspended BOOLEAN DEFAULT FALSE,
    suggestion_tag TEXT -- 'PLANAZO', 'NO FALLA', 'SALIDA SEGURA'
);

-- 2. Tabla de Entrevistas
CREATE TABLE interviews (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    published_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    title TEXT NOT NULL,
    subtitle TEXT,
    band_name TEXT,
    content TEXT NOT NULL,
    image_url TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    is_featured BOOLEAN DEFAULT FALSE,
    author TEXT,
    photo_credit TEXT,
    image_position TEXT DEFAULT 'center'
);

-- 3. Tabla de Auspiciantes / Publicidad
CREATE TABLE sponsors (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    client_name TEXT NOT NULL,
    image_url TEXT NOT NULL,
    link TEXT,
    position TEXT DEFAULT 'sidebar', -- 'top', 'sidebar', 'bottom'
    display_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE
);

-- 4. Tabla de Mensajes de Contacto
CREATE TABLE contact_messages (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT,
    message TEXT NOT NULL
);

-- Habilitar RLS (Seguridad a nivel de fila) - Opcional, pero recomendado
-- Por ahora permitimos lectura pública y escritura desde el admin (que usa Auth)
ALTER TABLE events ENABLE ROW LEVEL SECURITY;
ALTER TABLE interviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE sponsors ENABLE ROW LEVEL SECURITY;
ALTER TABLE contact_messages ENABLE ROW LEVEL SECURITY;

-- Políticas simples: Lectura para todos, Todo para autenticados
CREATE POLICY "Permitir lectura pública de eventos aprobados" ON events FOR SELECT USING (is_approved = true OR auth.role() = 'authenticated');
CREATE POLICY "Permitir inserción pública de eventos" ON events FOR INSERT WITH CHECK (true);
CREATE POLICY "Permitir todo a usuarios autenticados" ON events FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "Permitir lectura pública de entrevistas activas" ON interviews FOR SELECT USING (is_active = true OR auth.role() = 'authenticated');
CREATE POLICY "Permitir todo a usuarios autenticados" ON interviews FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "Permitir lectura pública de sponsors activos" ON sponsors FOR SELECT USING (is_active = true OR auth.role() = 'authenticated');
CREATE POLICY "Permitir todo a usuarios autenticados" ON sponsors FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "Permitir inserción pública de mensajes" ON contact_messages FOR INSERT WITH CHECK (true);
CREATE POLICY "Permitir todo a usuarios autenticados" ON contact_messages FOR ALL USING (auth.role() = 'authenticated');
