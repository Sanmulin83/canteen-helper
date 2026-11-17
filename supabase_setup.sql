-- ============================================================
-- 学期模式分表初始化脚本（在 Supabase SQL Editor 中执行）
-- 说明：代码会按模式读写带后缀的表：
--   recipes_term / aliases_term / menu_term   （学期）
--   recipes_winter / aliases_winter / menu_winter （寒假）
--   recipes_summer / aliases_summer / menu_summer （暑假）
-- 注意：本脚本按代码中用到的列名编写（dish_name/ingredients、
-- alias/target_dish、day_key/dishes）。若你库里的列名/类型不同，
-- 请先在 Supabase 仪表盘核对后再执行；CTAS 复制不会自动带 RLS 策略，
-- 新表需在仪表盘里把原表的 RLS 策略复制一份。
-- ============================================================

-- 1) 把现有无后缀表复制为学期表（原表保留不动，便于回退）
CREATE TABLE IF NOT EXISTS recipes_term AS SELECT * FROM recipes;
ALTER TABLE recipes_term ADD PRIMARY KEY (dish_name);

CREATE TABLE IF NOT EXISTS aliases_term AS SELECT * FROM aliases;
ALTER TABLE aliases_term ADD PRIMARY KEY (alias);

CREATE TABLE IF NOT EXISTS menu_term AS SELECT * FROM menu;
ALTER TABLE menu_term ADD PRIMARY KEY (day_key);

-- 2) 寒假空表（只复制结构，不带数据）
CREATE TABLE IF NOT EXISTS recipes_winter AS SELECT * FROM recipes_term WHERE 1=0;
ALTER TABLE recipes_winter ADD PRIMARY KEY (dish_name);

CREATE TABLE IF NOT EXISTS aliases_winter AS SELECT * FROM aliases_term WHERE 1=0;
ALTER TABLE aliases_winter ADD PRIMARY KEY (alias);

CREATE TABLE IF NOT EXISTS menu_winter AS SELECT * FROM menu_term WHERE 1=0;
ALTER TABLE menu_winter ADD PRIMARY KEY (day_key);

-- 3) 暑假空表（只复制结构，不带数据）
CREATE TABLE IF NOT EXISTS recipes_summer AS SELECT * FROM recipes_term WHERE 1=0;
ALTER TABLE recipes_summer ADD PRIMARY KEY (dish_name);

CREATE TABLE IF NOT EXISTS aliases_summer AS SELECT * FROM aliases_term WHERE 1=0;
ALTER TABLE aliases_summer ADD PRIMARY KEY (alias);

CREATE TABLE IF NOT EXISTS menu_summer AS SELECT * FROM menu_term WHERE 1=0;
ALTER TABLE menu_summer ADD PRIMARY KEY (day_key);
