-- Daily usage counters per user
CREATE TABLE IF NOT EXISTS usage_counters (
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  date DATE NOT NULL DEFAULT CURRENT_DATE,
  swipes_count INTEGER NOT NULL DEFAULT 0,
  ai_photo_count INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (user_id, date)
);

-- RLS
ALTER TABLE usage_counters ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own usage"
  ON usage_counters FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Service role manages usage"
  ON usage_counters FOR ALL
  USING (auth.role() = 'service_role');

-- Helper RPC function to safely increment a counter
CREATE OR REPLACE FUNCTION increment_usage(
  p_user_id UUID,
  p_date DATE,
  p_field TEXT
)
RETURNS VOID LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  IF p_field = 'swipes_count' THEN
    INSERT INTO usage_counters (user_id, date, swipes_count)
    VALUES (p_user_id, p_date, 1)
    ON CONFLICT (user_id, date)
    DO UPDATE SET swipes_count = usage_counters.swipes_count + 1;
  ELSIF p_field = 'ai_photo_count' THEN
    INSERT INTO usage_counters (user_id, date, ai_photo_count)
    VALUES (p_user_id, p_date, 1)
    ON CONFLICT (user_id, date)
    DO UPDATE SET ai_photo_count = usage_counters.ai_photo_count + 1;
  END IF;
END;
$$;
