CREATE OR REPLACE FUNCTION add_motherboards(
) RETURNS VOID AS $$
BEGIN
INSERT INTO Motherboards (
    price, model, manufacturer_code, country_of_origin, release_year, width_mm, length_mm, thickness_mm, weight_g, description, id_manufacturer, socket_id, chipset_id, form_factor_id, memory_type_id, max_memory_gb, mem_slots, memory_channels, sata_ports, m2_slots, sata_raid_support, usb_2_count, usb_3_count, usb_type_c_ports, rj45_ports, network_speed_gbps, wifi_standard, bluetooth_version, main_power_connector, cpu_power_connector, power_phase_count, chipset_passive_cooling, chipset_active_cooling, onboard_buttons, onboard_lighting, lighting_sync_software
    ) VALUES 
    (
    699, 'ROG Maximus Z790 Hero', 'ROG MAXIMUS Z790 HERO', 
    (select find_or_create_el('Countries','CHINA')), 
    2022, 305, 244, 46, 1850, 'Intel Z790 ATX',
    (find_or_create_manuf('MotherboardManufacturers',(find_or_create_manufacturer('ASUS','Taiwan')))), 
    (add_cpusocket('Intel','USA','LGA 1700')),
    (find_or_create_el('MotherboardChipsets','Intel Z790')), 
    (find_or_create_el('MotherboardsFormFactor','ATX')), 
    (find_or_create_el('DDRTypes','DDR4')), 
    128, 4, 2, 4, 5, TRUE, 4, 8, 1, 2, 2.5, 
    (find_or_create_el('WifiStandards','Wi-Fi 6E')), 
    (find_or_create_el('BluetoothStandards','5.3')), 
    (find_or_create_el('ATXConnectors','24-pin')), 
    (find_or_create_el('ATXConnectors','8-pin')), 
    20, TRUE, FALSE, TRUE, TRUE, TRUE
    ),
    ------
    ( 
    189, 'GIGABYTE B550 AORUS ELITE', 'B550 AORUS ELITE',
    (select find_or_create_el('Countries','TAIWAN')), 2021,
    305, 244, 46, 1850, 'AMD B550 ATX',
    (find_or_create_manuf('MotherboardManufacturers',(find_or_create_manufacturer('GIGABYTE','Taiwan')))),
    (add_cpusocket('AMD','USA','AM4')),
    (find_or_create_el('MotherboardChipsets','AMD B550')),
    (find_or_create_el('MotherboardsFormFactor','ATX')),
    (find_or_create_el('DDRTypes','DDR4')),
    128, 4, 2, 6, 2, TRUE, 4, 6, 1,
    1, 2.5, (find_or_create_el('WifiStandards','Wi-Fi 6E')),
    (find_or_create_el('BluetoothStandards','5.3')),
    (find_or_create_el('ATXConnectors','24-pin')),
    (find_or_create_el('ATXConnectors','8-pin')), 12,
    TRUE, FALSE, TRUE, FALSE, FALSE
    ),
    ------
    ( 
    279, 'MSI MPG Z590 GAMING CARBON WIFI', 'MPG Z590 GAMING CARBON WIFI',
    (select find_or_create_el('Countries','CHINA')), 2021,
    305, 244, 46, 1850,'Intel Z590 ATX',
    (find_or_create_manuf('MotherboardManufacturers',(find_or_create_manufacturer('MSI','China')))),
    (add_cpusocket('Intel','USA','LGA 1200')),
    (find_or_create_el('MotherboardChipsets','Intel Z590')),
    (find_or_create_el('MotherboardsFormFactor','ATX')),
    (find_or_create_el('DDRTypes','DDR4')),
    128, 4, 2, 6, 3, TRUE, 6, 8, 2,
    1, 2.5,(find_or_create_el('WifiStandards','Wi-Fi 6E')),
    (find_or_create_el('BluetoothStandards','5.2')),
    (find_or_create_el('ATXConnectors','24-pin')),
    (find_or_create_el('ATXConnectors','8-pin')),16,
    TRUE,FALSE,FALSE,FALSE,FALSE
    );
END;
$$ LANGUAGE plpgsql;
