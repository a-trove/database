CREATE OR REPLACE PROCEDURE update_name_groups()
LANGUAGE plpgsql
AS $$
DECLARE
    rec RECORD;
    v_count INTEGER := 0;
    v_group INTEGER := 1;
    v_curr_name TEXT := '';
    v_curr_list TEXT := '';
BEGIN
    -- Loop through rows ordered by Name, List, and Id
    FOR rec IN 
        SELECT Id, Name, List 
        FROM employees 
        ORDER BY Name, List, Id
    LOOP
        -- If group changes (Name or List), reset counters
        IF rec.Name <> v_curr_name OR rec.List <> v_curr_list THEN
            v_count := 1;
            v_group := 1;
            v_curr_name := rec.Name;
            v_curr_list := rec.List;
        ELSE
            v_count := v_count + 1;
            IF v_count > 2 THEN
                v_count := 1;
                v_group := v_group + 1;
            END IF;
        END IF;

        -- Update the row
        UPDATE employees
        SET Name = rec.Name || '_' || v_group
        WHERE Id = rec.Id;
    END LOOP;

    RAISE NOTICE 'Update completed.';
END;
$$;
