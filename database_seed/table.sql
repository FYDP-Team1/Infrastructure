-- Users table
CREATE TABLE
    users (
        id serial PRIMARY KEY,
        username varchar NOT NULL UNIQUE,
        created_at timestamp NOT NULL,
        updated_at timestamp NOT NULL,
        password varchar NOT NULL,
        meals_per_day smallint DEFAULT NULL,
        --CHECK (meals_per_day IN (1, 2, 3, 4))
        servings_per_meal smallint DEFAULT NULL,
        --CHECK (servings_per_meal IN (1, 2, 4)),
        max_cooking_minutes smallint DEFAULT NULL,
        weekly_budget decimal DEFAULT NULL -- decimal CHECK (weekly_budget > 0)
    );

-- Trigger function to update the updated_at column
CREATE
OR REPLACE FUNCTION update_modified_column () RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_user_modtime BEFORE
UPDATE ON users FOR EACH ROW
EXECUTE PROCEDURE update_modified_column ();

-- Dietary restrictions table
CREATE TABLE
    dietary_restrictions (
        id serial PRIMARY KEY,
        name varchar NOT NULL UNIQUE
    );

-- User preferences restrictions table
CREATE TABLE
    user_preferences_restrictions (
        user_id integer REFERENCES users (id) ON DELETE CASCADE,
        restriction_id integer REFERENCES dietary_restrictions (id),
        PRIMARY KEY (user_id, restriction_id)
    );

-- Cuisines table
CREATE TABLE
    cuisines (
        id serial PRIMARY KEY,
        name varchar NOT NULL UNIQUE
    );

-- User preferences cuisines table
CREATE TABLE
    user_preferences_cuisines (
        user_id integer REFERENCES users (id) ON DELETE CASCADE,
        cuisine_id integer REFERENCES cuisines (id),
        PRIMARY KEY (user_id, cuisine_id)
    );

-- Recipes table
CREATE TABLE
    recipes (
        id integer PRIMARY KEY,
        name varchar NOT NULL,
        description text NOT NULL,
        cooking_minutes smallint NOT NULL,
        cost decimal NOT NULL,
        n_steps smallint NOT NULL,
        steps text NOT NULL,
        n_ingredients smallint NOT NULL,
        calories decimal CHECK (calories >= 0) NOT NULL,
        total_fat_pdv decimal CHECK (total_fat_pdv >= 0) NOT NULL,
        sodium_pdv decimal CHECK (sodium_pdv >= 0) NOT NULL,
        protein_pdv decimal CHECK (protein_pdv >= 0) NOT NULL,
        saturated_fat_pdv decimal CHECK (saturated_fat_pdv >= 0) NOT NULL,
        carbohydrate_pdv decimal CHECK (carbohydrate_pdv >= 0) NOT NULL,
        sugar_pdv decimal CHECK (sugar_pdv >= 0) NOT NULL,
        cooking_method varchar NOT NULL,
        course varchar NOT NULL,
        difficulty varchar NOT NULL,
        dish varchar NOT NULL,
        equipment varchar NOT NULL,
        event varchar NOT NULL,
        key_ingredient varchar NOT NULL,
        season varchar NOT NULL
    );

-- Ingredients table
CREATE TABLE
    ingredients (
        id serial PRIMARY KEY,
        name VARCHAR NOT NULL UNIQUE
    );

-- Recipe ingredients table
CREATE TABLE
    recipe_ingredients (
        id serial PRIMARY KEY,
        recipe_id integer REFERENCES recipes (id),
        ingredient_id integer REFERENCES ingredients (id),
        label VARCHAR NOT NULL,
        quantity DECIMAL NOT NULL,
        unit VARCHAR NOT NULL
    );

-- Recipe restrictions table
CREATE TABLE
    recipe_restrictions (
        recipe_id integer REFERENCES recipes (id),
        restriction_id integer REFERENCES dietary_restrictions (id),
        PRIMARY KEY (recipe_id, restriction_id)
    );

-- Recipe cuisines table
CREATE TABLE
    recipe_cuisines (
        recipe_id integer REFERENCES recipes (id),
        cuisine_id integer REFERENCES cuisines (id),
        PRIMARY KEY (recipe_id, cuisine_id)
    );

-- Weekly schedules table
CREATE TABLE
    weekly_schedules (
        id serial PRIMARY KEY,
        user_id integer REFERENCES users (id) ON DELETE CASCADE,
        week_start_date date NOT NULL,
        cost decimal NOT NULL,
        UNIQUE (user_id, week_start_date)
    );

-- Scheduled recipes table
CREATE TABLE
    scheduled_recipes (
        schedule_id integer REFERENCES weekly_schedules (id) ON DELETE CASCADE,
        recipe_id integer REFERENCES recipes (id),
        cost decimal NOT NULL,
        day smallint NOT NULL,
        PRIMARY KEY (schedule_id, recipe_id, day)
    );