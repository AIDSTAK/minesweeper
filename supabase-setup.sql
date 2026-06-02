-- =====================================================
-- 扫雷游戏 Supabase 数据库初始化脚本
-- 在 Supabase 控制台 → SQL Editor 中运行此文件
-- =====================================================

-- 1. 用户信息表（扩展 Supabase 自带的 auth.users）
create table if not exists public.profiles (
  id          uuid primary key references auth.users(id) on delete cascade,
  username    text not null,
  created_at  timestamptz default now()
);

-- 2. 成绩表（每个用户每个难度只保留最佳）
create table if not exists public.scores (
  id           bigserial,
  user_id      uuid not null references auth.users(id) on delete cascade,
  username     text not null,
  difficulty   text not null check (difficulty in ('easy','medium','hard')),
  time_seconds integer not null check (time_seconds > 0),
  created_at   timestamptz default now(),
  -- 每个用户每个难度唯一，用于 upsert 保留最佳成绩
  unique (user_id, difficulty)
);

-- 3. 开启行级安全（RLS）
alter table public.profiles enable row level security;
alter table public.scores   enable row level security;

-- 4. profiles 权限
-- 用户可以读取所有人的 profile（用于显示排行榜用户名）
create policy "profiles: public read"
  on public.profiles for select using (true);

-- 用户只能修改自己的 profile
create policy "profiles: own write"
  on public.profiles for insert with check (auth.uid() = id);

create policy "profiles: own update"
  on public.profiles for update using (auth.uid() = id);

-- 5. scores 权限
-- 所有人可以查看排行榜
create policy "scores: public read"
  on public.scores for select using (true);

-- 登录用户可以插入/更新自己的成绩
create policy "scores: own insert"
  on public.scores for insert with check (auth.uid() = user_id);

create policy "scores: own update"
  on public.scores for update using (auth.uid() = user_id);

-- 6. 开启 Realtime（让排行榜实时更新）
alter publication supabase_realtime add table public.scores;

-- 完成！
