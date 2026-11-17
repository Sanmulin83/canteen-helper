-- ============================================================
-- 学期模式分表初始化脚本（在 Supabase SQL Editor 中执行）
-- 实际表结构（已核对）：
--   recipes: id(uuid) / dish_name(text) / ingredients(jsonb) / updated_at
--   aliases: id(uuid) / alias(text) / target_dish(text) / updated_at
--   menu:    day_key(text) / dishes(jsonb) / updated_at（无 id 列）
-- 说明：用 LIKE ... INCLUDING ALL 复制列、默认值、唯一约束和索引，
--       保证 upsert 的 onConflict(dish_name / alias / day_key) 仍然可用。
-- 注意：脚本只新增表，不删原表；重复执行前先手动清空目标表，避免数据翻倍。
-- ============================================================

-- 1) 学期表：复制原表结构 + 现有数据（recipes 941 条 / aliases 29 条 / menu 5 条）
CREATE TABLE IF NOT EXISTS recipes_term (LIKE recipes INCLUDING ALL);
INSERT INTO recipes_term SELECT * FROM recipes;

CREATE TABLE IF NOT EXISTS aliases_term (LIKE aliases INCLUDING ALL);
INSERT INTO aliases_term SELECT * FROM aliases;

CREATE TABLE IF NOT EXISTS menu_term (LIKE menu INCLUDING ALL);
INSERT INTO menu_term SELECT * FROM menu;

-- 2) 假期空表（寒假、暑假共用）：只复制结构，不带数据
CREATE TABLE IF NOT EXISTS recipes_vacation (LIKE recipes INCLUDING ALL);
CREATE TABLE IF NOT EXISTS aliases_vacation (LIKE aliases INCLUDING ALL);
CREATE TABLE IF NOT EXISTS menu_vacation (LIKE menu INCLUDING ALL);
