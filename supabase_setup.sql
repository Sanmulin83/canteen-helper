-- ============================================================
-- 学期模式分表初始化脚本（在 Supabase SQL Editor 中执行）
-- 说明：代码按模式读写带后缀的表，共两套：
--   recipes_term / aliases_term / menu_term         （学期）
--   recipes_vacation / aliases_vacation / menu_vacation （假期，寒假暑假共用）
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

-- 2) 假期空表（寒假、暑假共用，只复制结构不带数据）
CREATE TABLE IF NOT EXISTS recipes_vacation AS SELECT * FROM recipes_term WHERE 1=0;
ALTER TABLE recipes_vacation ADD PRIMARY KEY (dish_name);

CREATE TABLE IF NOT EXISTS aliases_vacation AS SELECT * FROM aliases_term WHERE 1=0;
ALTER TABLE aliases_vacation ADD PRIMARY KEY (alias);

CREATE TABLE IF NOT EXISTS menu_vacation AS SELECT * FROM menu_term WHERE 1=0;
ALTER TABLE menu_vacation ADD PRIMARY KEY (day_key);
