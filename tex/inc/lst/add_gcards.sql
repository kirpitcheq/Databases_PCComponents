CREATE OR REPLACE FUNCTION add_gcards(
) RETURNS VOID AS $$
BEGIN
    PERFORM add_gpu( 'NVIDIA', 'USA', 'NVIDIA RTX 4090', 'NVIDIA Ada Lovelace', '5nm', 2235, 2520, 16384, 512, 176, true, true, true
    ) ;

    PERFORM add_gpu( 'AMD', 'USA', 'AMD Radeon RX 7900 XTX', 'AMD RDNA3', '5nm', 1900, 2500 , 6144, 384, 192, true, true, true
    ) ;

INSERT INTO GraphicCards (
    price, model, manufacturer_code, country_of_origin, release_year, 
    width_mm, length_mm, thickness_mm, weight_g, description,
    id_manufacturer, mining_purpose, lhr, gpu_id, memory_capacity, memory_type_id, 
    memory_bus_width, memory_bandwidth, memory_clock_speed_mhz, simultaneous_monitors_count,
    max_resolution, connection_interface_id, pci_express_lines, additional_power_connectors, 
    recommended_power_supply, cooling_fan_count, liquid_cooling_radiator, low_profile
) VALUES (
    1599, 'ROG Strix GeForce RTX 4090', 'ROG-STRIX-RTX4090-O24G-GAMING', 
    (select find_or_create_el('Countries','CHINA')), 
    2022, 140.1, 357.6, 70.1, 2189, 'GeForce RTX 4090 24GB GDDR6X',
    (find_or_create_manuf('GraphicCardsManufacturers',(find_or_create_manufacturer('ASUS','Taiwan')))), 
    FALSE, TRUE, 
    (find_or_create_el('GPUs','NVIDIA RTX 4090')), 
    24, 
    (find_or_create_el('GDDRTypes','GDDR5')), 
    384, 1008, 21000, 4, '7680x4320', 
    (find_or_create_el('PCITypes','DisplayPort')), 
    16, TRUE, 850, 3, FALSE, FALSE
), (
    1999, 'AMD Radeon RX 7900XTX', 'RX7900XTX-24G', 
    3, 
    2023, 140, 300, 60, 2100, 'ASRock Radeon RX 7900XTX',
    (find_or_create_manuf('GraphicCardsManufacturers',(find_or_create_manufacturer('ASRock','Taiwan')))), 
    FALSE, TRUE, 
    (find_or_create_el('GPUs','AMD Radeon RX 7900 XTX')), 
    24, 
    (find_or_create_el('GDDRTypes','GDDR5')), 
    384, 10500, 22000, 4, '7680x4320', 
    (find_or_create_el('PCITypes','DisplayPort')), 
    16, TRUE, 850, 3, FALSE, FALSE);

END;
$$ LANGUAGE plpgsql;
