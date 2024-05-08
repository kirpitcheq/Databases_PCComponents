CREATE OR REPLACE FUNCTION add_ssdsm2(
) RETURNS VOID AS $$
BEGIN
INSERT INTO SSDM2 (
    price, model, manufacturer_code, country_of_origin, release_year, 
    width_mm, length_mm, thickness_mm, weight_g, description,
    id_manufacturer, capacity_mb, interface_type_id, form_factor_id,
    mem_structure_id, max_sequential_read_speed_mbps, max_sequential_write_speed_mbps,
    max_write_endurance_tb, hardware_encryption, key_m2_id, nvme
) VALUES (
    229, '980 PRO 2TB', 'MZ-V8P2T0BW', 
    (select find_or_create_el('Countries','CHINA')), 
    2020, 22.15, 80.15, 2.38, 9, '2TB PCIe Gen 4.0 x4 NVMe M.2',
    (find_or_create_manuf('NonVolMemManufacturers',(find_or_create_manufacturer('Samsung','South Korea')))), 
    2000000, 
    (find_or_create_el('InterfaceType', 'SATA')),
    (find_or_create_el('NonVolMemFormfact', '3.5')),
    (find_or_create_el('SSDMemStruct', '3DNand')),
    7000, 5100, 1200, TRUE, 
    (find_or_create_el('SSDM2Key', 'M|B')),
    TRUE),
    ------
    ( 149, 'KC2500 1TB', 'KC2500/1000G',
    (select find_or_create_el('Countries','TAIWAN')), 2021,
    22.15, 80.15, 2.38, 9, '1TB NVMe PCIe Gen 3.0 x4 M.2',
    (find_or_create_manuf('NonVolMemManufacturers',(find_or_create_manufacturer('Kingston','TAIWAN')))),
    1000,
    (find_or_create_el('InterfaceType', 'NVMe PCIe Gen 3.0 x4')),
    (find_or_create_el('NonVolMemFormfact', 'M.2 2280')),
    (find_or_create_el('SSDMemStruct', '3DNand')), 3500, 2900,
    800, TRUE,
    (find_or_create_el('SSDM2Key', 'M|B')), TRUE),
    ------
    ( 79, 'NE-512', 'NE-512G',
    (select find_or_create_el('Countries','CHINA')), 2020,
    22.15, 80.15, 2.38, 9, '512GB SATA III M.2',
    (find_or_create_manuf('NonVolMemManufacturers',(find_or_create_manufacturer('KingSpec','CHINA')))),
    512,
    (find_or_create_el('InterfaceType', 'SATA III')),
    (find_or_create_el('NonVolMemFormfact', 'M.2 2280')),
    (find_or_create_el('SSDMemStruct', '3DNand')), 550, 420,
    400, TRUE,
    (find_or_create_el('SSDM2Key', 'M|B')), TRUE);
END;
$$ LANGUAGE plpgsql;
