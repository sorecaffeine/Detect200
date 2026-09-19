CREATE TABLE IF NOT EXISTS checks (
    id INTEGER PRIMARY KEY,
    timestamp TEXT NOT NULL,
    service TEXT NOT NULL,
    http_status INTEGER,
    success INTEGER NOT NULL CHECK (success IN(0,1))
);
