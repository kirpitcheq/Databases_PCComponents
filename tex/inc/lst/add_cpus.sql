CREATE OR REPLACE FUNCTION add_cpus(
) RETURNS VOID AS $$
BEGIN
INSERT INTO CPUs (
    price, model, manufacturer_code, country_of_origin, release_year, 
    width_mm, length_mm, thickness_mm, weight_g, description,
    socket_id, cores_count, threads_count, cache_l2_mb, cache_l3_mb, technology_process_nm, core_id, 
    base_clock_speed, max_turbo_clock_speed, unlocked_multiplier, mem_type_id, max_supported_memory_mb,
    memory_channels, memory_frequency_hz, ecc_support, tdp_watt, base_tdp_watt, max_cpu_temp, 
    integrated_graphics, integrated_pci_express_controller, pci_express_lanes, virtualization_technology
) VALUES (
    589, 'Core i9-13900K', 'BX8071513900K', 
    (select find_or_create_el('Countries','CHINA')), 
    2022, 37.5, 37.5, 4.4, 100, '24-ядерный процессор 3.0 ГГц',
    (add_cpusocket('Intel','USA','LGA 1700')),
    24, 32, 32, 36, 10, 
    (find_or_create_el('CPUCores','Raptor Lake')), 
    3.0, 5.8, TRUE, 
    (find_or_create_el('DDRTypes','DDR4')), 
    128, 2, 5200, FALSE, 125, 125, 100,
    TRUE, TRUE, 20, TRUE),
    (
    699, 'Ryzen 9 7950X', '100-000000514', 
    (select find_or_create_el('Countries','CHINA')), 
    2022, 40, 40, 4.4, 70, '16-ядерный процессор 4.5 ГГц',
    (add_cpusocket('AMD','USA','AM5')),
    16, 32, 16, 64, 5, 
    (find_or_create_el('CPUCores','Raptor Lake')), 
    4.5, 5.7, TRUE, 
    (find_or_create_el('DDRTypes','DDR5')), 
    128, 2, 5200, TRUE, 170, 105, 95,
    FALSE, TRUE, 24, TRUE); 
END;
$$ LANGUAGE plpgsql;
