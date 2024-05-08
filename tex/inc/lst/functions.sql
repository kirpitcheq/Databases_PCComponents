---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION find_or_create_el(_tbl regclass, _name TEXT, OUT result INT)
  LANGUAGE plpgsql AS
$func$
BEGIN
   EXECUTE format('SELECT id FROM %s WHERE name = $1', _tbl)
   INTO result USING _name;
    IF result IS NULL THEN
        EXECUTE format('INSERT INTO %s (name) VALUES ($1) RETURNING id', _tbl) INTO result USING _name;
    END IF;
END
$func$;
---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION find_or_create_manufacturer(
    _name TEXT,country_name TEXT
) RETURNS INT AS $$
DECLARE 
    _id INT;
    _country_id INT;
BEGIN
    SELECT find_or_create_el('Countries', country_name) INTO _country_id;
    SELECT find_or_create_el('Manufacturers', _name) INTO _id;
    UPDATE Manufacturers SET country_id=_country_id WHERE id=_id;
    RETURN _id;
END;
$$ LANGUAGE plpgsql;
---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION find_or_create_manuf(_tbl regclass, _id_manuf INT, OUT result INT)
  LANGUAGE plpgsql AS
$func$
BEGIN
   EXECUTE format('SELECT id FROM %s WHERE id_manufacturer = $1', _tbl)
   INTO result USING _id_manuf;
    IF result IS NULL THEN
        EXECUTE format('INSERT INTO %s (id_manufacturer) VALUES ($1) RETURNING id', _tbl) INTO result USING _id_manuf;
    END IF;
END
$func$;
---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION add_cpusocket(
    manufacturerName VARCHAR(100), 
    manufacturerCountry VARCHAR(100),
    socket_name VARCHAR(100)
) RETURNS INT AS $$
DECLARE
    _manufacturer_ID INT; _CPUmanufacturer_ID INT; _CPUsocketID INT; _CPUsockmanID INT; 
BEGIN
    SELECT find_or_create_manufacturer(manufacturerName, manufacturerCountry) INTO _manufacturer_ID;
    SELECT find_or_create_manuf('CPUManufacturers', _manufacturer_ID) INTO _CPUmanufacturer_ID;
    SELECT find_or_create_el('CPUSockets', socket_name) INTO _CPUsocketID;
    SELECT id_manufacturer INTO _CPUsockmanID FROM CPUSockets WHERE id=_CPUsocketID;
    IF _CPUsockmanID IS NULL THEN
        UPDATE CPUSockets SET id_manufacturer=_CPUmanufacturer_ID WHERE id=_CPUsocketID;
    END IF;
    RETURN _CPUsocketID;
END;
$$ LANGUAGE plpgsql;
---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION add_gpu(
    manufacturerName VARCHAR(100), 
    manufacturerCountry VARCHAR(100),
---------
    _name VARCHAR(100),
    microarchitecture VARCHAR(50),
    technology_process VARCHAR(10),
    base_clock_speed INTEGER,
    turbo_clock_speed INTEGER,
    alu_count INTEGER,
    texture_block_count INTEGER,
    rasterization_block_count INTEGER,
    ray_tracing_support BOOLEAN,
    rt_cores BOOLEAN,
    tensor_cores BOOLEAN
) RETURNS INT AS $$
DECLARE
    _manufacturer_ID INT; _GPUmanufacturer_ID INT; _resultID INT;
BEGIN
    -- Добавление производителя
    SELECT find_or_create_manufacturer(manufacturerName, manufacturerCountry) INTO _manufacturer_ID;
    SELECT find_or_create_manuf('GPUManufacturers', _manufacturer_ID) INTO _GPUmanufacturer_ID;

    INSERT INTO GPUs ( name , id_manufacturer , microarchitecture , technology_process , base_clock_speed , turbo_clock_speed , alu_count , texture_block_count , rasterization_block_count , ray_tracing_support , rt_cores , tensor_cores )
    VALUES( _name , _GPUmanufacturer_ID, microarchitecture , technology_process , base_clock_speed , turbo_clock_speed , alu_count , texture_block_count , rasterization_block_count , ray_tracing_support , rt_cores , tensor_cores ) RETURNING id INTO _resultID;

    RETURN _resultID;
END;
$$ LANGUAGE plpgsql;
---------------------------------------------------------------------

