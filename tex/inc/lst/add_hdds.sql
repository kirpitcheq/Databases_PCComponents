CREATE OR REPLACE FUNCTION add_hdds(
) RETURNS VOID AS $$
BEGIN

INSERT INTO HDD (
    price, model, manufacturer_code, country_of_origin, release_year, 
    width_mm, length_mm, thickness_mm, weight_g, description,
    id_manufacturer, capacity_mb, interface_type_id, form_factor_id,
    volume_gb, cache_mb, spindle_speed, max_data_transfer_speed_mbps, 
    latency_ms, raid_optimization, recording_technology_id, operating_shock_resistance_g,
    operating_noise_level_db, idle_noise_level_db, helium_filled, positioning_parking_cycles,
    max_power_consumption_w, idle_power_consumption_w, max_operating_temperature_c
) VALUES (
    529, 'IronWolf Pro 18TB', 'ST18000NE000', 
    (find_or_create_el('Countries','CHINA')), 
    2022, 101.6, 146.99, 26.11, 705, '18TB 7200RPM SATA 6Gb/s 3.5"',
    (find_or_create_manuf('NonVolMemManufacturers',(find_or_create_manufacturer('Seagate','USA')))), 
    18000000, 
    (find_or_create_el('InterfaceType', 'SATA')),
    (find_or_create_el('NonVolMemFormfact', '3.5')),
    18, 256, 7200, 285, 4.16, TRUE, 
    (find_or_create_el('RecTechHDD', 'CMR')),
    70, 28, 20, TRUE, 600000, 7.5, 4.5, 70 ),

    (129, 'Seagate BarraCuda 4TB', 'ST4000DM004', 
    (find_or_create_el('Countries','USA')), 
    2021, 101.6, 146.99, 26.11, 705, '',
    (find_or_create_manuf('NonVolMemManufacturers',(find_or_create_manufacturer('Seagate','USA')))), 
    400000,
    (find_or_create_el('InterfaceType', 'SATA')), (find_or_create_el('NonVolMemFormfact', '3.5')),
    40, 256, 5400, 190, 6, FALSE, 
    (find_or_create_el('RecTechHDD', 'SMR')),
    70, 26, 20, TRUE, 700000, 8, 5, 60),

    (249, 'WD Black 6TB', 'WD6003FZBX', 
    (find_or_create_el('Countries','Thailand')), 
    2020, 101.6, 146.99, 26.11, 705, '',
    (find_or_create_manuf('NonVolMemManufacturers',(find_or_create_manufacturer('Western Digital','USA')))), 
    6000, 
    (find_or_create_el('InterfaceType', 'SATA')), (find_or_create_el('NonVolMemFormfact', '3.5')),
    6000, 256, 7200, 256, 4.2, TRUE, 
    (find_or_create_el('RecTechHDD', 'CMR')),
    65, 28, 22, TRUE, 80000, 10, 7, 65);

END;
$$ LANGUAGE plpgsql;
