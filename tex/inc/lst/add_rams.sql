CREATE OR REPLACE FUNCTION add_rams(
) RETURNS VOID AS $$
BEGIN
    INSERT INTO RAM (
        price, model, manufacturer_code, country_of_origin, release_year,
        width_mm, length_mm, thickness_mm, weight_g, description,
        id_manufacturer, memory_type_id, form_factor_id, modules_count, memory_mb, voltage, frequency_mhz
        )
    VALUES 
        (
        100, 'HyperX Fury DDR4', 'HX426C16FB3K2/16', 
        (select find_or_create_el('Countries','CHINA')), 
        2020, 32.00, 133.35, 7.20, 60, 
        'DDR4-3200 16GB Kit (2x8GB) CL16 DIMM', 
        (find_or_create_manuf('RAMManufacturers',(find_or_create_manufacturer('HyperX','USA')))), 
        (find_or_create_el('DDRTypes','DDR4')), 
        (find_or_create_el('DIMMTypes','DIMM')), 
        2, 16384, 1.35, 3200
        ), 
        (
        120, 'HyperX Fury DDR4 RGB', 'HX436C17FB3AK2/16', 
        (select find_or_create_el('Countries','CHINA')), 
        2021, 34.1, 133.35, 8, 70, 
        'DDR4-3600 CL17 16GB Kit (2x8GB)', 
        (find_or_create_manuf('RAMManufacturers',(find_or_create_manufacturer('HyperX','USA')))), 
        (find_or_create_el('DDRTypes','DDR4')), 
        (find_or_create_el('DIMMTypes','DIMM')), 
        2, 16384, 1.35, 3600
        ),
        (
        40, 'Kingston ValueRAM DDR4', 'KVR26S19S8/8', 
        (select find_or_create_el('Countries','CHINA')), 
        2022, 30, 69.6, 3.8, 20, 
        'DDR4-2666 SO-DIMM 8GB CL19', 
        (find_or_create_manuf('RAMManufacturers',(find_or_create_manufacturer('Kingston','USA')))), 
        (find_or_create_el('DDRTypes','DDR4')), 
        (find_or_create_el('DIMMTypes','SO-DIMM')), 
        1, 8192, 1.2, 2666
        );
END;
$$ LANGUAGE plpgsql;
