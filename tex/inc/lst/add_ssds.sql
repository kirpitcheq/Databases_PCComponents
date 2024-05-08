CREATE OR REPLACE FUNCTION add_ssds(
) RETURNS VOID AS $$
BEGIN
INSERT INTO SSD (
    price, model, manufacturer_code, country_of_origin, release_year, 
    width_mm, length_mm, thickness_mm, weight_g, description,
    id_manufacturer, capacity_mb, interface_type_id, form_factor_id,
    mem_structure_id, max_sequential_read_speed_mbps, max_sequential_write_speed_mbps,
    max_write_endurance_tb, hardware_encryption
) VALUES (
    229, 'Samsung 870 EVO', 'MZ-77E1T0BW/EU', 
    (select find_or_create_el('Countries','CHINA')), 
    2020, 69.85, 100, 6.8, 45, '2TB PCIe Gen 4.0 x4 NVMe M.2',
    (find_or_create_manuf('NonVolMemManufacturers',(find_or_create_manufacturer('Samsung','South Korea')))), 
    10000000, 
    (find_or_create_el('InterfaceType', 'SATA')),
    (find_or_create_el('NonVolMemFormfact', '2.5')),
    (find_or_create_el('SSDMemStruct', '3DNand')),
    560, 530, 600, TRUE),
------
    (179, 'Toshiba X300', 'HDWF180UZSVA', 
    (select find_or_create_el('Countries','PHILIPPINES')), 
    2021, 101.6, 147, 26.1, 450, '8TB SATA III 3.5"', (find_or_create_manuf('NonVolMemManufacturers',(find_or_create_manufacturer('Toshiba','Japan')))), 
    8000000, 
    (find_or_create_el('InterfaceType', 'SATA')), (find_or_create_el('NonVolMemFormfact', '3.5')), (find_or_create_el('SSDMemStruct', 'HDD')), 
    210, 200, 4.5, FALSE),
------
    (149, 'Gigabyte AORUS RGB', 'GP-AG41TB', 
    (select find_or_create_el('Countries','TAIWAN')), 
    2020, 80.15, 22.15, 2.38, 15.5, '1TB PCIe Gen 4.0 x4 NVMe M.2', (find_or_create_manuf('NonVolMemManufacturers',(find_or_create_manufacturer('Gigabyte','Taiwan')))), 
    1000000, 
    (find_or_create_el('InterfaceType', 'NVMe')), (find_or_create_el('NonVolMemFormfact', 'M.2')), (find_or_create_el('SSDMemStruct', '3DNand')), 
    7000, 5500, 1.2, TRUE);
END;
$$ LANGUAGE plpgsql;
