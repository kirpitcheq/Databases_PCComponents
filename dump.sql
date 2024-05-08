--
-- PostgreSQL database dump
--

-- Dumped from database version 15.6 (Ubuntu 15.6-0ubuntu0.23.10.1)
-- Dumped by pg_dump version 15.6 (Ubuntu 15.6-0ubuntu0.23.10.1)

-- Started on 2024-05-08 16:27:48 MSK

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 310 (class 1255 OID 19987)
-- Name: add_cpus(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_cpus() RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.add_cpus() OWNER TO postgres;

--
-- TOC entry 297 (class 1255 OID 19985)
-- Name: add_cpusocket(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_cpusocket(manufacturername character varying, manufacturercountry character varying, socket_name character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.add_cpusocket(manufacturername character varying, manufacturercountry character varying, socket_name character varying) OWNER TO postgres;

--
-- TOC entry 316 (class 1255 OID 19989)
-- Name: add_gcards(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_gcards() RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.add_gcards() OWNER TO postgres;

--
-- TOC entry 309 (class 1255 OID 19986)
-- Name: add_gpu(character varying, character varying, character varying, character varying, character varying, integer, integer, integer, integer, integer, boolean, boolean, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_gpu(manufacturername character varying, manufacturercountry character varying, _name character varying, microarchitecture character varying, technology_process character varying, base_clock_speed integer, turbo_clock_speed integer, alu_count integer, texture_block_count integer, rasterization_block_count integer, ray_tracing_support boolean, rt_cores boolean, tensor_cores boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.add_gpu(manufacturername character varying, manufacturercountry character varying, _name character varying, microarchitecture character varying, technology_process character varying, base_clock_speed integer, turbo_clock_speed integer, alu_count integer, texture_block_count integer, rasterization_block_count integer, ray_tracing_support boolean, rt_cores boolean, tensor_cores boolean) OWNER TO postgres;

--
-- TOC entry 311 (class 1255 OID 19990)
-- Name: add_hdds(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_hdds() RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.add_hdds() OWNER TO postgres;

--
-- TOC entry 312 (class 1255 OID 19991)
-- Name: add_motherboards(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_motherboards() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
INSERT INTO Motherboards (
    price, model, manufacturer_code, country_of_origin, release_year, width_mm, length_mm, thickness_mm, weight_g, description, id_manufacturer, socket_id, chipset_id, form_factor_id, memory_type_id, max_memory_gb, mem_slots, memory_channels, sata_ports, m2_slots, sata_raid_support, usb_2_count, usb_3_count, usb_type_c_ports, rj45_ports, network_speed_gbps, wifi_standard, bluetooth_version, main_power_connector, cpu_power_connector, power_phase_count, chipset_passive_cooling, chipset_active_cooling, onboard_buttons, onboard_lighting, lighting_sync_software
    ) VALUES (
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
    20, TRUE, FALSE, TRUE, TRUE, TRUE),
    ------
    ( 189, 'GIGABYTE B550 AORUS ELITE', 'B550 AORUS ELITE',
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
    TRUE, FALSE, TRUE, FALSE, FALSE),
    ------
    ( 279, 'MSI MPG Z590 GAMING CARBON WIFI', 'MPG Z590 GAMING CARBON WIFI',
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
    TRUE,FALSE,FALSE,FALSE,FALSE);
END;
$$;


ALTER FUNCTION public.add_motherboards() OWNER TO postgres;

--
-- TOC entry 313 (class 1255 OID 19992)
-- Name: add_rams(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_rams() RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.add_rams() OWNER TO postgres;

--
-- TOC entry 314 (class 1255 OID 19994)
-- Name: add_ssds(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_ssds() RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.add_ssds() OWNER TO postgres;

--
-- TOC entry 315 (class 1255 OID 19995)
-- Name: add_ssdsm2(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_ssdsm2() RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.add_ssdsm2() OWNER TO postgres;

--
-- TOC entry 294 (class 1255 OID 19982)
-- Name: find_or_create_el(regclass, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.find_or_create_el(_tbl regclass, _name text, OUT result integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
BEGIN
   EXECUTE format('SELECT id FROM %s WHERE name = $1', _tbl)
   INTO result USING _name;
    IF result IS NULL THEN
        EXECUTE format('INSERT INTO %s (name) VALUES ($1) RETURNING id', _tbl) INTO result USING _name;
    END IF;
END
$_$;


ALTER FUNCTION public.find_or_create_el(_tbl regclass, _name text, OUT result integer) OWNER TO postgres;

--
-- TOC entry 296 (class 1255 OID 19984)
-- Name: find_or_create_manuf(regclass, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.find_or_create_manuf(_tbl regclass, _id_manuf integer, OUT result integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
BEGIN
   EXECUTE format('SELECT id FROM %s WHERE id_manufacturer = $1', _tbl)
   INTO result USING _id_manuf;
    IF result IS NULL THEN
        EXECUTE format('INSERT INTO %s (id_manufacturer) VALUES ($1) RETURNING id', _tbl) INTO result USING _id_manuf;
    END IF;
END
$_$;


ALTER FUNCTION public.find_or_create_manuf(_tbl regclass, _id_manuf integer, OUT result integer) OWNER TO postgres;

--
-- TOC entry 295 (class 1255 OID 19983)
-- Name: find_or_create_manufacturer(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.find_or_create_manufacturer(_name text, country_name text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE 
    _id INT;
    _country_id INT;
BEGIN
    SELECT find_or_create_el('Countries', country_name) INTO _country_id;
    SELECT find_or_create_el('Manufacturers', _name) INTO _id;
    UPDATE Manufacturers SET country_id=_country_id WHERE id=_id;
    RETURN _id;
END;
$$;


ALTER FUNCTION public.find_or_create_manufacturer(_name text, country_name text) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 276 (class 1259 OID 19788)
-- Name: atxconnectors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.atxconnectors (
    id integer NOT NULL,
    name character varying(50)
);


ALTER TABLE public.atxconnectors OWNER TO postgres;

--
-- TOC entry 275 (class 1259 OID 19787)
-- Name: atxconnectors_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.atxconnectors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.atxconnectors_id_seq OWNER TO postgres;

--
-- TOC entry 3739 (class 0 OID 0)
-- Dependencies: 275
-- Name: atxconnectors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.atxconnectors_id_seq OWNED BY public.atxconnectors.id;


--
-- TOC entry 268 (class 1259 OID 19760)
-- Name: audiochipsets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audiochipsets (
    id integer NOT NULL,
    name character varying(50)
);


ALTER TABLE public.audiochipsets OWNER TO postgres;

--
-- TOC entry 267 (class 1259 OID 19759)
-- Name: audiochipsets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.audiochipsets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.audiochipsets_id_seq OWNER TO postgres;

--
-- TOC entry 3742 (class 0 OID 0)
-- Dependencies: 267
-- Name: audiochipsets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.audiochipsets_id_seq OWNED BY public.audiochipsets.id;


--
-- TOC entry 274 (class 1259 OID 19781)
-- Name: bluetoothstandards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bluetoothstandards (
    id integer NOT NULL,
    name character varying(50)
);


ALTER TABLE public.bluetoothstandards OWNER TO postgres;

--
-- TOC entry 273 (class 1259 OID 19780)
-- Name: bluetoothstandards_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bluetoothstandards_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bluetoothstandards_id_seq OWNER TO postgres;

--
-- TOC entry 3745 (class 0 OID 0)
-- Dependencies: 273
-- Name: bluetoothstandards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bluetoothstandards_id_seq OWNED BY public.bluetoothstandards.id;


--
-- TOC entry 219 (class 1259 OID 19460)
-- Name: components; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.components (
    component_id integer NOT NULL,
    price integer,
    model character varying(100),
    manufacturer_code character varying(50),
    country_of_origin integer,
    release_year integer,
    width_mm numeric(6,2),
    length_mm numeric(6,2),
    thickness_mm numeric(6,2),
    weight_g integer,
    description character varying(100)
);


ALTER TABLE public.components OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 19459)
-- Name: components_component_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.components_component_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.components_component_id_seq OWNER TO postgres;

--
-- TOC entry 3748 (class 0 OID 0)
-- Dependencies: 218
-- Name: components_component_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.components_component_id_seq OWNED BY public.components.component_id;


--
-- TOC entry 215 (class 1259 OID 19441)
-- Name: countries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.countries (
    id integer NOT NULL,
    name character varying(100)
);


ALTER TABLE public.countries OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 19440)
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.countries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.countries_id_seq OWNER TO postgres;

--
-- TOC entry 3751 (class 0 OID 0)
-- Dependencies: 214
-- Name: countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.countries_id_seq OWNED BY public.countries.id;


--
-- TOC entry 230 (class 1259 OID 19529)
-- Name: cpucores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cpucores (
    id integer NOT NULL,
    name character varying(50)
);


ALTER TABLE public.cpucores OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 19528)
-- Name: cpucores_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cpucores_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cpucores_id_seq OWNER TO postgres;

--
-- TOC entry 3754 (class 0 OID 0)
-- Dependencies: 229
-- Name: cpucores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cpucores_id_seq OWNED BY public.cpucores.id;


--
-- TOC entry 228 (class 1259 OID 19517)
-- Name: cpumanufacturers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cpumanufacturers (
    id integer NOT NULL,
    id_manufacturer integer
);


ALTER TABLE public.cpumanufacturers OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 19516)
-- Name: cpumanufacturers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cpumanufacturers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cpumanufacturers_id_seq OWNER TO postgres;

--
-- TOC entry 3757 (class 0 OID 0)
-- Dependencies: 227
-- Name: cpumanufacturers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cpumanufacturers_id_seq OWNED BY public.cpumanufacturers.id;


--
-- TOC entry 233 (class 1259 OID 19547)
-- Name: cpus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cpus (
    socket_id integer,
    cores_count integer,
    threads_count integer,
    cache_l2_mb integer,
    cache_l3_mb integer,
    technology_process_nm integer,
    core_id integer,
    base_clock_speed double precision,
    max_turbo_clock_speed double precision,
    unlocked_multiplier boolean,
    mem_type_id integer,
    max_supported_memory_mb integer,
    memory_channels integer,
    memory_frequency_hz integer,
    ecc_support boolean,
    tdp_watt integer,
    base_tdp_watt integer,
    max_cpu_temp double precision,
    integrated_graphics boolean,
    integrated_pci_express_controller boolean,
    pci_express_lanes integer,
    virtualization_technology boolean
)
INHERITS (public.components);


ALTER TABLE public.cpus OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 19536)
-- Name: cpusockets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cpusockets (
    id integer NOT NULL,
    name character varying(50),
    id_manufacturer integer
);


ALTER TABLE public.cpusockets OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 19535)
-- Name: cpusockets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cpusockets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cpusockets_id_seq OWNER TO postgres;

--
-- TOC entry 3761 (class 0 OID 0)
-- Dependencies: 231
-- Name: cpusockets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cpusockets_id_seq OWNED BY public.cpusockets.id;


--
-- TOC entry 223 (class 1259 OID 19484)
-- Name: ddrtypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ddrtypes (
    id integer NOT NULL,
    name character varying(50),
    speed_mhz integer
);


ALTER TABLE public.ddrtypes OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 19483)
-- Name: ddrtypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ddrtypes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ddrtypes_id_seq OWNER TO postgres;

--
-- TOC entry 3764 (class 0 OID 0)
-- Dependencies: 222
-- Name: ddrtypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ddrtypes_id_seq OWNED BY public.ddrtypes.id;


--
-- TOC entry 225 (class 1259 OID 19491)
-- Name: dimmtypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dimmtypes (
    id integer NOT NULL,
    name character varying(50)
);


ALTER TABLE public.dimmtypes OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 19490)
-- Name: dimmtypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dimmtypes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dimmtypes_id_seq OWNER TO postgres;

--
-- TOC entry 3767 (class 0 OID 0)
-- Dependencies: 224
-- Name: dimmtypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dimmtypes_id_seq OWNED BY public.dimmtypes.id;


--
-- TOC entry 283 (class 1259 OID 19878)
-- Name: fantypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fantypes (
    id integer NOT NULL,
    name character varying(50)
);


ALTER TABLE public.fantypes OWNER TO postgres;

--
-- TOC entry 282 (class 1259 OID 19877)
-- Name: fantypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fantypes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fantypes_id_seq OWNER TO postgres;

--
-- TOC entry 3770 (class 0 OID 0)
-- Dependencies: 282
-- Name: fantypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fantypes_id_seq OWNED BY public.fantypes.id;


--
-- TOC entry 239 (class 1259 OID 19591)
-- Name: gddrtypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gddrtypes (
    id integer NOT NULL,
    name character varying(50)
);


ALTER TABLE public.gddrtypes OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 19590)
-- Name: gddrtypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.gddrtypes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gddrtypes_id_seq OWNER TO postgres;

--
-- TOC entry 3773 (class 0 OID 0)
-- Dependencies: 238
-- Name: gddrtypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.gddrtypes_id_seq OWNED BY public.gddrtypes.id;


--
-- TOC entry 235 (class 1259 OID 19567)
-- Name: gpumanufacturers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gpumanufacturers (
    id integer NOT NULL,
    id_manufacturer integer
);


ALTER TABLE public.gpumanufacturers OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 19566)
-- Name: gpumanufacturers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.gpumanufacturers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gpumanufacturers_id_seq OWNER TO postgres;

--
-- TOC entry 3776 (class 0 OID 0)
-- Dependencies: 234
-- Name: gpumanufacturers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.gpumanufacturers_id_seq OWNED BY public.gpumanufacturers.id;


--
-- TOC entry 237 (class 1259 OID 19579)
-- Name: gpus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gpus (
    id integer NOT NULL,
    name character varying(100),
    id_manufacturer integer,
    microarchitecture character varying(50),
    technology_process character varying(10),
    base_clock_speed integer,
    turbo_clock_speed integer,
    alu_count integer,
    texture_block_count integer,
    rasterization_block_count integer,
    ray_tracing_support boolean,
    rt_cores boolean,
    tensor_cores boolean
);


ALTER TABLE public.gpus OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 19578)
-- Name: gpus_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.gpus_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gpus_id_seq OWNER TO postgres;

--
-- TOC entry 3779 (class 0 OID 0)
-- Dependencies: 236
-- Name: gpus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.gpus_id_seq OWNED BY public.gpus.id;


--
-- TOC entry 246 (class 1259 OID 19623)
-- Name: graphiccards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.graphiccards (
    id_manufacturer integer,
    mining_purpose boolean,
    lhr boolean,
    gpu_id integer,
    memory_capacity integer,
    memory_type_id integer,
    memory_bus_width integer,
    memory_bandwidth integer,
    memory_clock_speed_mhz integer,
    simultaneous_monitors_count integer,
    max_resolution character varying(20),
    connection_interface_id integer,
    pci_express_lines integer,
    additional_power_connectors boolean,
    recommended_power_supply integer,
    cooling_fan_count integer,
    liquid_cooling_radiator boolean,
    low_profile boolean
)
INHERITS (public.components);


ALTER TABLE public.graphiccards OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 19612)
-- Name: graphiccardsmanufacturers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.graphiccardsmanufacturers (
    id integer NOT NULL,
    id_manufacturer integer
);


ALTER TABLE public.graphiccardsmanufacturers OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 19611)
-- Name: graphiccardsmanufacturers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.graphiccardsmanufacturers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.graphiccardsmanufacturers_id_seq OWNER TO postgres;

--
-- TOC entry 3783 (class 0 OID 0)
-- Dependencies: 244
-- Name: graphiccardsmanufacturers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.graphiccardsmanufacturers_id_seq OWNED BY public.graphiccardsmanufacturers.id;


--
-- TOC entry 241 (class 1259 OID 19598)
-- Name: graphouts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.graphouts (
    id integer NOT NULL,
    name character varying(50)
);


ALTER TABLE public.graphouts OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 19597)
-- Name: graphouts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.graphouts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.graphouts_id_seq OWNER TO postgres;

--
-- TOC entry 3786 (class 0 OID 0)
-- Dependencies: 240
-- Name: graphouts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.graphouts_id_seq OWNED BY public.graphouts.id;


--
-- TOC entry 253 (class 1259 OID 19673)
-- Name: nonvolatilemem; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nonvolatilemem (
    id_manufacturer integer,
    capacity_mb integer,
    interface_type_id integer,
    form_factor_id integer
)
INHERITS (public.components);


ALTER TABLE public.nonvolatilemem OWNER TO postgres;

--
-- TOC entry 256 (class 1259 OID 19699)
-- Name: hdd; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hdd (
    volume_gb integer,
    cache_mb integer,
    spindle_speed integer,
    max_data_transfer_speed_mbps integer,
    latency_ms numeric(4,2),
    raid_optimization boolean,
    recording_technology_id integer,
    operating_shock_resistance_g numeric(4,2),
    operating_noise_level_db numeric(4,2),
    idle_noise_level_db numeric(4,2),
    helium_filled boolean,
    positioning_parking_cycles integer,
    max_power_consumption_w numeric(4,2),
    idle_power_consumption_w numeric(4,2),
    max_operating_temperature_c integer
)
INHERITS (public.nonvolatilemem);


ALTER TABLE public.hdd OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 19660)
-- Name: interfacetype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.interfacetype (
    id integer NOT NULL,
    name character varying(50),
    interface_throughput_gbps numeric(4,2)
);


ALTER TABLE public.interfacetype OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 19659)
-- Name: interfacetype_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.interfacetype_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.interfacetype_id_seq OWNER TO postgres;

--
-- TOC entry 3791 (class 0 OID 0)
-- Dependencies: 249
-- Name: interfacetype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.interfacetype_id_seq OWNED BY public.interfacetype.id;


--
-- TOC entry 217 (class 1259 OID 19448)
-- Name: manufacturers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.manufacturers (
    id integer NOT NULL,
    name character varying(100),
    country_id integer
);


ALTER TABLE public.manufacturers OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 19447)
-- Name: manufacturers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.manufacturers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.manufacturers_id_seq OWNER TO postgres;

--
-- TOC entry 3794 (class 0 OID 0)
-- Dependencies: 216
-- Name: manufacturers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.manufacturers_id_seq OWNED BY public.manufacturers.id;


--
-- TOC entry 278 (class 1259 OID 19795)
-- Name: motherboardchipsets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.motherboardchipsets (
    id integer NOT NULL,
    name character varying(50)
);


ALTER TABLE public.motherboardchipsets OWNER TO postgres;

--
-- TOC entry 277 (class 1259 OID 19794)
-- Name: motherboardchipsets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.motherboardchipsets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.motherboardchipsets_id_seq OWNER TO postgres;

--
-- TOC entry 3797 (class 0 OID 0)
-- Dependencies: 277
-- Name: motherboardchipsets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.motherboardchipsets_id_seq OWNED BY public.motherboardchipsets.id;


--
-- TOC entry 264 (class 1259 OID 19741)
-- Name: motherboardmanufacturers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.motherboardmanufacturers (
    id integer NOT NULL,
    id_manufacturer integer
);


ALTER TABLE public.motherboardmanufacturers OWNER TO postgres;

--
-- TOC entry 263 (class 1259 OID 19740)
-- Name: motherboardmanufacturers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.motherboardmanufacturers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.motherboardmanufacturers_id_seq OWNER TO postgres;

--
-- TOC entry 3800 (class 0 OID 0)
-- Dependencies: 263
-- Name: motherboardmanufacturers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.motherboardmanufacturers_id_seq OWNED BY public.motherboardmanufacturers.id;


--
-- TOC entry 279 (class 1259 OID 19801)
-- Name: motherboards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.motherboards (
    form_factor_id integer,
    id_manufacturer integer,
    compatible_cpu_cores character varying(100),
    socket_id integer,
    chipset_id integer,
    memory_type_id integer,
    memory_formfactor_id integer,
    mem_slots integer,
    memory_channels integer,
    max_memory_gb integer,
    max_memory_speed_mhz integer,
    pci_slots integer,
    sli_crossfire_support boolean,
    nvme_support boolean,
    m2_slots integer,
    m2_e_slots integer,
    sata_ports integer,
    sata_raid_support boolean,
    ide_ports integer,
    usb_2_count integer,
    usb_3_count integer,
    usb_type_a_ports integer,
    usb_type_c_ports integer,
    vga_ports integer,
    rj45_ports integer,
    analog_audio_ports integer,
    spdif_ports boolean,
    sma_ports boolean,
    ps2_ports boolean,
    internal_usb_type_a_ports integer,
    internal_usb_type_c_ports integer,
    cpu_cooler_power_pin integer,
    case_fan_3pin_ports integer,
    case_fan_4pin_ports integer,
    argb_fan_ports boolean,
    rgb_fan_ports boolean,
    rs232_com_ports boolean,
    lpt_interface boolean,
    audio_chipset_id integer,
    network_speed_gbps numeric(3,1),
    network_adapter_id integer,
    wifi_standard integer,
    bluetooth_version integer,
    main_power_connector integer,
    cpu_power_connector integer,
    power_phase_count integer,
    chipset_passive_cooling boolean,
    chipset_active_cooling boolean,
    onboard_buttons boolean,
    onboard_lighting boolean,
    lighting_sync_software boolean
)
INHERITS (public.components);


ALTER TABLE public.motherboards OWNER TO postgres;

--
-- TOC entry 266 (class 1259 OID 19753)
-- Name: motherboardsformfactor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.motherboardsformfactor (
    id integer NOT NULL,
    name character varying(50)
);


ALTER TABLE public.motherboardsformfactor OWNER TO postgres;

--
-- TOC entry 265 (class 1259 OID 19752)
-- Name: motherboardsformfactor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.motherboardsformfactor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.motherboardsformfactor_id_seq OWNER TO postgres;

--
-- TOC entry 3804 (class 0 OID 0)
-- Dependencies: 265
-- Name: motherboardsformfactor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.motherboardsformfactor_id_seq OWNED BY public.motherboardsformfactor.id;


--
-- TOC entry 270 (class 1259 OID 19767)
-- Name: networkadapters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.networkadapters (
    id integer NOT NULL,
    name character varying(50)
);


ALTER TABLE public.networkadapters OWNER TO postgres;

--
-- TOC entry 269 (class 1259 OID 19766)
-- Name: networkadapters_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.networkadapters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.networkadapters_id_seq OWNER TO postgres;

--
-- TOC entry 3807 (class 0 OID 0)
-- Dependencies: 269
-- Name: networkadapters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.networkadapters_id_seq OWNED BY public.networkadapters.id;


--
-- TOC entry 252 (class 1259 OID 19667)
-- Name: nonvolmemformfact; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nonvolmemformfact (
    id integer NOT NULL,
    name character varying(50)
);


ALTER TABLE public.nonvolmemformfact OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 19666)
-- Name: nonvolmemformfact_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nonvolmemformfact_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nonvolmemformfact_id_seq OWNER TO postgres;

--
-- TOC entry 3810 (class 0 OID 0)
-- Dependencies: 251
-- Name: nonvolmemformfact_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.nonvolmemformfact_id_seq OWNED BY public.nonvolmemformfact.id;


--
-- TOC entry 248 (class 1259 OID 19648)
-- Name: nonvolmemmanufacturers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nonvolmemmanufacturers (
    id integer NOT NULL,
    id_manufacturer integer
);


ALTER TABLE public.nonvolmemmanufacturers OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 19647)
-- Name: nonvolmemmanufacturers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nonvolmemmanufacturers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nonvolmemmanufacturers_id_seq OWNER TO postgres;

--
-- TOC entry 3813 (class 0 OID 0)
-- Dependencies: 247
-- Name: nonvolmemmanufacturers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.nonvolmemmanufacturers_id_seq OWNED BY public.nonvolmemmanufacturers.id;


--
-- TOC entry 292 (class 1259 OID 19950)
-- Name: pccaseformfactors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pccaseformfactors (
    id integer NOT NULL,
    name character varying(50)
);


ALTER TABLE public.pccaseformfactors OWNER TO postgres;

--
-- TOC entry 291 (class 1259 OID 19949)
-- Name: pccaseformfactors_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pccaseformfactors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pccaseformfactors_id_seq OWNER TO postgres;

--
-- TOC entry 3816 (class 0 OID 0)
-- Dependencies: 291
-- Name: pccaseformfactors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pccaseformfactors_id_seq OWNED BY public.pccaseformfactors.id;


--
-- TOC entry 293 (class 1259 OID 19956)
-- Name: pccases; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pccases (
    id_manufacturer integer,
    formfactor_id integer,
    motherboard_orientation character varying(20),
    primary_color character varying(20),
    main_material character varying(50),
    side_panel_window boolean,
    front_panel_material character varying(50),
    lighting_type character varying(50),
    compatible_motherboard_formfactors integer,
    compatible_power_supply_form_factors integer,
    power_supply_placement character varying(20),
    horizontal_expansion_slots integer,
    vertical_expansion_slots integer,
    max_gpu_length_mm integer,
    max_cpu_cooler_height_mm integer,
    internal_2_5_drive_bays_count integer,
    internal_3_5_drive_bays_count integer,
    external_3_5_drive_bays_count integer,
    external_5_25_drive_bays_count integer,
    included_fans boolean,
    liquid_cooling_support boolean,
    front_panel_io_location character varying(20),
    built_in_card_reader boolean,
    side_panel_fixation character varying(50),
    cpu_cooler_cutout boolean,
    cable_management boolean,
    built_in_psu boolean,
    silent_features boolean,
    package_contents character varying(50)
)
INHERITS (public.components);


ALTER TABLE public.pccases OWNER TO postgres;

--
-- TOC entry 290 (class 1259 OID 19938)
-- Name: pccasesmanufacturers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pccasesmanufacturers (
    id integer NOT NULL,
    id_manufacturer integer
);


ALTER TABLE public.pccasesmanufacturers OWNER TO postgres;

--
-- TOC entry 289 (class 1259 OID 19937)
-- Name: pccasesmanufacturers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pccasesmanufacturers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pccasesmanufacturers_id_seq OWNER TO postgres;

--
-- TOC entry 3820 (class 0 OID 0)
-- Dependencies: 289
-- Name: pccasesmanufacturers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pccasesmanufacturers_id_seq OWNED BY public.pccasesmanufacturers.id;


--
-- TOC entry 243 (class 1259 OID 19605)
-- Name: pcitypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pcitypes (
    id integer NOT NULL,
    name character varying(50)
);


ALTER TABLE public.pcitypes OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 19604)
-- Name: pcitypes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pcitypes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pcitypes_id_seq OWNER TO postgres;

--
-- TOC entry 3823 (class 0 OID 0)
-- Dependencies: 242
-- Name: pcitypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pcitypes_id_seq OWNED BY public.pcitypes.id;


--
-- TOC entry 288 (class 1259 OID 19898)
-- Name: powersupplies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.powersupplies (
    id_manufacturer integer,
    power_rate_w integer,
    form_factor_id integer,
    detachable_cables boolean,
    cable_sleeving boolean,
    lighting boolean,
    main_power_connector integer,
    cpu_power_connectors integer,
    pci_e_power_connectors integer,
    sata_power_connectors integer,
    molex_power_connectors integer,
    floppy_power_connector boolean,
    main_power_cable_length integer,
    cpu_power_cable_length integer,
    sata_power_cable_length integer,
    molex_power_cable_length integer,
    power_12v_rating integer,
    current_12v_line double precision,
    current_3v3_line double precision,
    current_5v_line double precision,
    standby_power_current double precision,
    current_negative_12v double precision,
    input_110v_60hz boolean,
    input_220v_50hz boolean,
    cooling_system character varying(50),
    fan_size_id integer,
    fan_autospeed_control boolean,
    hybrid_mode_switch boolean,
    efficiency_certification boolean,
    power_factor_correction boolean,
    protection_technologies_ids integer
)
INHERITS (public.components);


ALTER TABLE public.powersupplies OWNER TO postgres;

--
-- TOC entry 285 (class 1259 OID 19885)
-- Name: powersupplyformfactors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.powersupplyformfactors (
    id integer NOT NULL,
    name character varying(50)
);


ALTER TABLE public.powersupplyformfactors OWNER TO postgres;

--
-- TOC entry 284 (class 1259 OID 19884)
-- Name: powersupplyformfactors_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.powersupplyformfactors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.powersupplyformfactors_id_seq OWNER TO postgres;

--
-- TOC entry 3827 (class 0 OID 0)
-- Dependencies: 284
-- Name: powersupplyformfactors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.powersupplyformfactors_id_seq OWNED BY public.powersupplyformfactors.id;


--
-- TOC entry 281 (class 1259 OID 19866)
-- Name: powersupplymanufacturers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.powersupplymanufacturers (
    id integer NOT NULL,
    id_manufacturer integer
);


ALTER TABLE public.powersupplymanufacturers OWNER TO postgres;

--
-- TOC entry 280 (class 1259 OID 19865)
-- Name: powersupplymanufacturers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.powersupplymanufacturers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.powersupplymanufacturers_id_seq OWNER TO postgres;

--
-- TOC entry 3830 (class 0 OID 0)
-- Dependencies: 280
-- Name: powersupplymanufacturers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.powersupplymanufacturers_id_seq OWNED BY public.powersupplymanufacturers.id;


--
-- TOC entry 287 (class 1259 OID 19892)
-- Name: psuprotectiontechnologies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.psuprotectiontechnologies (
    id integer NOT NULL,
    name character varying(50)
);


ALTER TABLE public.psuprotectiontechnologies OWNER TO postgres;

--
-- TOC entry 286 (class 1259 OID 19891)
-- Name: psuprotectiontechnologies_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.psuprotectiontechnologies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.psuprotectiontechnologies_id_seq OWNER TO postgres;

--
-- TOC entry 3833 (class 0 OID 0)
-- Dependencies: 286
-- Name: psuprotectiontechnologies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.psuprotectiontechnologies_id_seq OWNED BY public.psuprotectiontechnologies.id;


--
-- TOC entry 226 (class 1259 OID 19497)
-- Name: ram; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ram (
    id_manufacturer integer,
    memory_type_id integer,
    form_factor_id integer,
    modules_count integer,
    memory_mb integer,
    voltage double precision,
    frequency_mhz integer
)
INHERITS (public.components);


ALTER TABLE public.ram OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 19472)
-- Name: rammanufacturers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rammanufacturers (
    id integer NOT NULL,
    id_manufacturer integer
);


ALTER TABLE public.rammanufacturers OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 19471)
-- Name: rammanufacturers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rammanufacturers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rammanufacturers_id_seq OWNER TO postgres;

--
-- TOC entry 3837 (class 0 OID 0)
-- Dependencies: 220
-- Name: rammanufacturers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rammanufacturers_id_seq OWNED BY public.rammanufacturers.id;


--
-- TOC entry 255 (class 1259 OID 19693)
-- Name: rectechhdd; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rectechhdd (
    id integer NOT NULL,
    name character varying(50)
);


ALTER TABLE public.rectechhdd OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 19692)
-- Name: rectechhdd_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rectechhdd_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rectechhdd_id_seq OWNER TO postgres;

--
-- TOC entry 3840 (class 0 OID 0)
-- Dependencies: 254
-- Name: rectechhdd_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rectechhdd_id_seq OWNED BY public.rectechhdd.id;


--
-- TOC entry 259 (class 1259 OID 19715)
-- Name: ssd; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ssd (
    mem_structure_id integer,
    max_sequential_read_speed_mbps integer,
    max_sequential_write_speed_mbps integer,
    max_write_endurance_tb integer,
    hardware_encryption boolean
)
INHERITS (public.nonvolatilemem);


ALTER TABLE public.ssd OWNER TO postgres;

--
-- TOC entry 262 (class 1259 OID 19731)
-- Name: ssdm2; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ssdm2 (
    key_m2_id integer,
    nvme boolean
)
INHERITS (public.ssd);


ALTER TABLE public.ssdm2 OWNER TO postgres;

--
-- TOC entry 261 (class 1259 OID 19725)
-- Name: ssdm2key; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ssdm2key (
    id integer NOT NULL,
    name character varying(50),
    cell_bits character varying(10)
);


ALTER TABLE public.ssdm2key OWNER TO postgres;

--
-- TOC entry 260 (class 1259 OID 19724)
-- Name: ssdm2key_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ssdm2key_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ssdm2key_id_seq OWNER TO postgres;

--
-- TOC entry 3845 (class 0 OID 0)
-- Dependencies: 260
-- Name: ssdm2key_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ssdm2key_id_seq OWNED BY public.ssdm2key.id;


--
-- TOC entry 258 (class 1259 OID 19709)
-- Name: ssdmemstruct; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ssdmemstruct (
    id integer NOT NULL,
    name character varying(50),
    cell_bits character varying(10)
);


ALTER TABLE public.ssdmemstruct OWNER TO postgres;

--
-- TOC entry 257 (class 1259 OID 19708)
-- Name: ssdmemstruct_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ssdmemstruct_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ssdmemstruct_id_seq OWNER TO postgres;

--
-- TOC entry 3848 (class 0 OID 0)
-- Dependencies: 257
-- Name: ssdmemstruct_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ssdmemstruct_id_seq OWNED BY public.ssdmemstruct.id;


--
-- TOC entry 272 (class 1259 OID 19774)
-- Name: wifistandards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wifistandards (
    id integer NOT NULL,
    name character varying(50)
);


ALTER TABLE public.wifistandards OWNER TO postgres;

--
-- TOC entry 271 (class 1259 OID 19773)
-- Name: wifistandards_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.wifistandards_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wifistandards_id_seq OWNER TO postgres;

--
-- TOC entry 3851 (class 0 OID 0)
-- Dependencies: 271
-- Name: wifistandards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.wifistandards_id_seq OWNED BY public.wifistandards.id;


--
-- TOC entry 3459 (class 2604 OID 19791)
-- Name: atxconnectors id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.atxconnectors ALTER COLUMN id SET DEFAULT nextval('public.atxconnectors_id_seq'::regclass);


--
-- TOC entry 3455 (class 2604 OID 19763)
-- Name: audiochipsets id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audiochipsets ALTER COLUMN id SET DEFAULT nextval('public.audiochipsets_id_seq'::regclass);


--
-- TOC entry 3458 (class 2604 OID 19784)
-- Name: bluetoothstandards id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bluetoothstandards ALTER COLUMN id SET DEFAULT nextval('public.bluetoothstandards_id_seq'::regclass);


--
-- TOC entry 3427 (class 2604 OID 19463)
-- Name: components component_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.components ALTER COLUMN component_id SET DEFAULT nextval('public.components_component_id_seq'::regclass);


--
-- TOC entry 3425 (class 2604 OID 19444)
-- Name: countries id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries ALTER COLUMN id SET DEFAULT nextval('public.countries_id_seq'::regclass);


--
-- TOC entry 3433 (class 2604 OID 19532)
-- Name: cpucores id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpucores ALTER COLUMN id SET DEFAULT nextval('public.cpucores_id_seq'::regclass);


--
-- TOC entry 3432 (class 2604 OID 19520)
-- Name: cpumanufacturers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpumanufacturers ALTER COLUMN id SET DEFAULT nextval('public.cpumanufacturers_id_seq'::regclass);


--
-- TOC entry 3435 (class 2604 OID 19550)
-- Name: cpus component_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpus ALTER COLUMN component_id SET DEFAULT nextval('public.components_component_id_seq'::regclass);


--
-- TOC entry 3434 (class 2604 OID 19539)
-- Name: cpusockets id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpusockets ALTER COLUMN id SET DEFAULT nextval('public.cpusockets_id_seq'::regclass);


--
-- TOC entry 3429 (class 2604 OID 19487)
-- Name: ddrtypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ddrtypes ALTER COLUMN id SET DEFAULT nextval('public.ddrtypes_id_seq'::regclass);


--
-- TOC entry 3430 (class 2604 OID 19494)
-- Name: dimmtypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dimmtypes ALTER COLUMN id SET DEFAULT nextval('public.dimmtypes_id_seq'::regclass);


--
-- TOC entry 3463 (class 2604 OID 19881)
-- Name: fantypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fantypes ALTER COLUMN id SET DEFAULT nextval('public.fantypes_id_seq'::regclass);


--
-- TOC entry 3438 (class 2604 OID 19594)
-- Name: gddrtypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gddrtypes ALTER COLUMN id SET DEFAULT nextval('public.gddrtypes_id_seq'::regclass);


--
-- TOC entry 3436 (class 2604 OID 19570)
-- Name: gpumanufacturers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gpumanufacturers ALTER COLUMN id SET DEFAULT nextval('public.gpumanufacturers_id_seq'::regclass);


--
-- TOC entry 3437 (class 2604 OID 19582)
-- Name: gpus id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gpus ALTER COLUMN id SET DEFAULT nextval('public.gpus_id_seq'::regclass);


--
-- TOC entry 3442 (class 2604 OID 19626)
-- Name: graphiccards component_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.graphiccards ALTER COLUMN component_id SET DEFAULT nextval('public.components_component_id_seq'::regclass);


--
-- TOC entry 3441 (class 2604 OID 19615)
-- Name: graphiccardsmanufacturers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.graphiccardsmanufacturers ALTER COLUMN id SET DEFAULT nextval('public.graphiccardsmanufacturers_id_seq'::regclass);


--
-- TOC entry 3439 (class 2604 OID 19601)
-- Name: graphouts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.graphouts ALTER COLUMN id SET DEFAULT nextval('public.graphouts_id_seq'::regclass);


--
-- TOC entry 3448 (class 2604 OID 19702)
-- Name: hdd component_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hdd ALTER COLUMN component_id SET DEFAULT nextval('public.components_component_id_seq'::regclass);


--
-- TOC entry 3444 (class 2604 OID 19663)
-- Name: interfacetype id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interfacetype ALTER COLUMN id SET DEFAULT nextval('public.interfacetype_id_seq'::regclass);


--
-- TOC entry 3426 (class 2604 OID 19451)
-- Name: manufacturers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.manufacturers ALTER COLUMN id SET DEFAULT nextval('public.manufacturers_id_seq'::regclass);


--
-- TOC entry 3460 (class 2604 OID 19798)
-- Name: motherboardchipsets id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.motherboardchipsets ALTER COLUMN id SET DEFAULT nextval('public.motherboardchipsets_id_seq'::regclass);


--
-- TOC entry 3453 (class 2604 OID 19744)
-- Name: motherboardmanufacturers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.motherboardmanufacturers ALTER COLUMN id SET DEFAULT nextval('public.motherboardmanufacturers_id_seq'::regclass);


--
-- TOC entry 3461 (class 2604 OID 19804)
-- Name: motherboards component_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.motherboards ALTER COLUMN component_id SET DEFAULT nextval('public.components_component_id_seq'::regclass);


--
-- TOC entry 3454 (class 2604 OID 19756)
-- Name: motherboardsformfactor id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.motherboardsformfactor ALTER COLUMN id SET DEFAULT nextval('public.motherboardsformfactor_id_seq'::regclass);


--
-- TOC entry 3456 (class 2604 OID 19770)
-- Name: networkadapters id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.networkadapters ALTER COLUMN id SET DEFAULT nextval('public.networkadapters_id_seq'::regclass);


--
-- TOC entry 3446 (class 2604 OID 19676)
-- Name: nonvolatilemem component_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nonvolatilemem ALTER COLUMN component_id SET DEFAULT nextval('public.components_component_id_seq'::regclass);


--
-- TOC entry 3445 (class 2604 OID 19670)
-- Name: nonvolmemformfact id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nonvolmemformfact ALTER COLUMN id SET DEFAULT nextval('public.nonvolmemformfact_id_seq'::regclass);


--
-- TOC entry 3443 (class 2604 OID 19651)
-- Name: nonvolmemmanufacturers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nonvolmemmanufacturers ALTER COLUMN id SET DEFAULT nextval('public.nonvolmemmanufacturers_id_seq'::regclass);


--
-- TOC entry 3468 (class 2604 OID 19953)
-- Name: pccaseformfactors id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pccaseformfactors ALTER COLUMN id SET DEFAULT nextval('public.pccaseformfactors_id_seq'::regclass);


--
-- TOC entry 3469 (class 2604 OID 19959)
-- Name: pccases component_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pccases ALTER COLUMN component_id SET DEFAULT nextval('public.components_component_id_seq'::regclass);


--
-- TOC entry 3467 (class 2604 OID 19941)
-- Name: pccasesmanufacturers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pccasesmanufacturers ALTER COLUMN id SET DEFAULT nextval('public.pccasesmanufacturers_id_seq'::regclass);


--
-- TOC entry 3440 (class 2604 OID 19608)
-- Name: pcitypes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pcitypes ALTER COLUMN id SET DEFAULT nextval('public.pcitypes_id_seq'::regclass);


--
-- TOC entry 3466 (class 2604 OID 19901)
-- Name: powersupplies component_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.powersupplies ALTER COLUMN component_id SET DEFAULT nextval('public.components_component_id_seq'::regclass);


--
-- TOC entry 3464 (class 2604 OID 19888)
-- Name: powersupplyformfactors id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.powersupplyformfactors ALTER COLUMN id SET DEFAULT nextval('public.powersupplyformfactors_id_seq'::regclass);


--
-- TOC entry 3462 (class 2604 OID 19869)
-- Name: powersupplymanufacturers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.powersupplymanufacturers ALTER COLUMN id SET DEFAULT nextval('public.powersupplymanufacturers_id_seq'::regclass);


--
-- TOC entry 3465 (class 2604 OID 19895)
-- Name: psuprotectiontechnologies id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.psuprotectiontechnologies ALTER COLUMN id SET DEFAULT nextval('public.psuprotectiontechnologies_id_seq'::regclass);


--
-- TOC entry 3431 (class 2604 OID 19500)
-- Name: ram component_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ram ALTER COLUMN component_id SET DEFAULT nextval('public.components_component_id_seq'::regclass);


--
-- TOC entry 3428 (class 2604 OID 19475)
-- Name: rammanufacturers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rammanufacturers ALTER COLUMN id SET DEFAULT nextval('public.rammanufacturers_id_seq'::regclass);


--
-- TOC entry 3447 (class 2604 OID 19696)
-- Name: rectechhdd id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rectechhdd ALTER COLUMN id SET DEFAULT nextval('public.rectechhdd_id_seq'::regclass);


--
-- TOC entry 3450 (class 2604 OID 19718)
-- Name: ssd component_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ssd ALTER COLUMN component_id SET DEFAULT nextval('public.components_component_id_seq'::regclass);


--
-- TOC entry 3452 (class 2604 OID 19734)
-- Name: ssdm2 component_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ssdm2 ALTER COLUMN component_id SET DEFAULT nextval('public.components_component_id_seq'::regclass);


--
-- TOC entry 3451 (class 2604 OID 19728)
-- Name: ssdm2key id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ssdm2key ALTER COLUMN id SET DEFAULT nextval('public.ssdm2key_id_seq'::regclass);


--
-- TOC entry 3449 (class 2604 OID 19712)
-- Name: ssdmemstruct id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ssdmemstruct ALTER COLUMN id SET DEFAULT nextval('public.ssdmemstruct_id_seq'::regclass);


--
-- TOC entry 3457 (class 2604 OID 19777)
-- Name: wifistandards id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wifistandards ALTER COLUMN id SET DEFAULT nextval('public.wifistandards_id_seq'::regclass);


--
-- TOC entry 3525 (class 2606 OID 19793)
-- Name: atxconnectors atxconnectors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.atxconnectors
    ADD CONSTRAINT atxconnectors_pkey PRIMARY KEY (id);


--
-- TOC entry 3517 (class 2606 OID 19765)
-- Name: audiochipsets audiochipsets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audiochipsets
    ADD CONSTRAINT audiochipsets_pkey PRIMARY KEY (id);


--
-- TOC entry 3523 (class 2606 OID 19786)
-- Name: bluetoothstandards bluetoothstandards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bluetoothstandards
    ADD CONSTRAINT bluetoothstandards_pkey PRIMARY KEY (id);


--
-- TOC entry 3475 (class 2606 OID 19465)
-- Name: components components_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.components
    ADD CONSTRAINT components_pkey PRIMARY KEY (component_id);


--
-- TOC entry 3471 (class 2606 OID 19446)
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- TOC entry 3485 (class 2606 OID 19534)
-- Name: cpucores cpucores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpucores
    ADD CONSTRAINT cpucores_pkey PRIMARY KEY (id);


--
-- TOC entry 3483 (class 2606 OID 19522)
-- Name: cpumanufacturers cpumanufacturers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpumanufacturers
    ADD CONSTRAINT cpumanufacturers_pkey PRIMARY KEY (id);


--
-- TOC entry 3487 (class 2606 OID 19541)
-- Name: cpusockets cpusockets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpusockets
    ADD CONSTRAINT cpusockets_pkey PRIMARY KEY (id);


--
-- TOC entry 3479 (class 2606 OID 19489)
-- Name: ddrtypes ddrtypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ddrtypes
    ADD CONSTRAINT ddrtypes_pkey PRIMARY KEY (id);


--
-- TOC entry 3481 (class 2606 OID 19496)
-- Name: dimmtypes dimmtypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dimmtypes
    ADD CONSTRAINT dimmtypes_pkey PRIMARY KEY (id);


--
-- TOC entry 3531 (class 2606 OID 19883)
-- Name: fantypes fantypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fantypes
    ADD CONSTRAINT fantypes_pkey PRIMARY KEY (id);


--
-- TOC entry 3493 (class 2606 OID 19596)
-- Name: gddrtypes gddrtypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gddrtypes
    ADD CONSTRAINT gddrtypes_pkey PRIMARY KEY (id);


--
-- TOC entry 3489 (class 2606 OID 19572)
-- Name: gpumanufacturers gpumanufacturers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gpumanufacturers
    ADD CONSTRAINT gpumanufacturers_pkey PRIMARY KEY (id);


--
-- TOC entry 3491 (class 2606 OID 19584)
-- Name: gpus gpus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gpus
    ADD CONSTRAINT gpus_pkey PRIMARY KEY (id);


--
-- TOC entry 3499 (class 2606 OID 19617)
-- Name: graphiccardsmanufacturers graphiccardsmanufacturers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.graphiccardsmanufacturers
    ADD CONSTRAINT graphiccardsmanufacturers_pkey PRIMARY KEY (id);


--
-- TOC entry 3495 (class 2606 OID 19603)
-- Name: graphouts graphouts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.graphouts
    ADD CONSTRAINT graphouts_pkey PRIMARY KEY (id);


--
-- TOC entry 3503 (class 2606 OID 19665)
-- Name: interfacetype interfacetype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interfacetype
    ADD CONSTRAINT interfacetype_pkey PRIMARY KEY (id);


--
-- TOC entry 3473 (class 2606 OID 19453)
-- Name: manufacturers manufacturers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.manufacturers
    ADD CONSTRAINT manufacturers_pkey PRIMARY KEY (id);


--
-- TOC entry 3527 (class 2606 OID 19800)
-- Name: motherboardchipsets motherboardchipsets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.motherboardchipsets
    ADD CONSTRAINT motherboardchipsets_pkey PRIMARY KEY (id);


--
-- TOC entry 3513 (class 2606 OID 19746)
-- Name: motherboardmanufacturers motherboardmanufacturers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.motherboardmanufacturers
    ADD CONSTRAINT motherboardmanufacturers_pkey PRIMARY KEY (id);


--
-- TOC entry 3515 (class 2606 OID 19758)
-- Name: motherboardsformfactor motherboardsformfactor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.motherboardsformfactor
    ADD CONSTRAINT motherboardsformfactor_pkey PRIMARY KEY (id);


--
-- TOC entry 3519 (class 2606 OID 19772)
-- Name: networkadapters networkadapters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.networkadapters
    ADD CONSTRAINT networkadapters_pkey PRIMARY KEY (id);


--
-- TOC entry 3505 (class 2606 OID 19672)
-- Name: nonvolmemformfact nonvolmemformfact_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nonvolmemformfact
    ADD CONSTRAINT nonvolmemformfact_pkey PRIMARY KEY (id);


--
-- TOC entry 3501 (class 2606 OID 19653)
-- Name: nonvolmemmanufacturers nonvolmemmanufacturers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nonvolmemmanufacturers
    ADD CONSTRAINT nonvolmemmanufacturers_pkey PRIMARY KEY (id);


--
-- TOC entry 3539 (class 2606 OID 19955)
-- Name: pccaseformfactors pccaseformfactors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pccaseformfactors
    ADD CONSTRAINT pccaseformfactors_pkey PRIMARY KEY (id);


--
-- TOC entry 3537 (class 2606 OID 19943)
-- Name: pccasesmanufacturers pccasesmanufacturers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pccasesmanufacturers
    ADD CONSTRAINT pccasesmanufacturers_pkey PRIMARY KEY (id);


--
-- TOC entry 3497 (class 2606 OID 19610)
-- Name: pcitypes pcitypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pcitypes
    ADD CONSTRAINT pcitypes_pkey PRIMARY KEY (id);


--
-- TOC entry 3533 (class 2606 OID 19890)
-- Name: powersupplyformfactors powersupplyformfactors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.powersupplyformfactors
    ADD CONSTRAINT powersupplyformfactors_pkey PRIMARY KEY (id);


--
-- TOC entry 3529 (class 2606 OID 19871)
-- Name: powersupplymanufacturers powersupplymanufacturers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.powersupplymanufacturers
    ADD CONSTRAINT powersupplymanufacturers_pkey PRIMARY KEY (id);


--
-- TOC entry 3535 (class 2606 OID 19897)
-- Name: psuprotectiontechnologies psuprotectiontechnologies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.psuprotectiontechnologies
    ADD CONSTRAINT psuprotectiontechnologies_pkey PRIMARY KEY (id);


--
-- TOC entry 3477 (class 2606 OID 19477)
-- Name: rammanufacturers rammanufacturers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rammanufacturers
    ADD CONSTRAINT rammanufacturers_pkey PRIMARY KEY (id);


--
-- TOC entry 3507 (class 2606 OID 19698)
-- Name: rectechhdd rectechhdd_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rectechhdd
    ADD CONSTRAINT rectechhdd_pkey PRIMARY KEY (id);


--
-- TOC entry 3511 (class 2606 OID 19730)
-- Name: ssdm2key ssdm2key_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ssdm2key
    ADD CONSTRAINT ssdm2key_pkey PRIMARY KEY (id);


--
-- TOC entry 3509 (class 2606 OID 19714)
-- Name: ssdmemstruct ssdmemstruct_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ssdmemstruct
    ADD CONSTRAINT ssdmemstruct_pkey PRIMARY KEY (id);


--
-- TOC entry 3521 (class 2606 OID 19779)
-- Name: wifistandards wifistandards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wifistandards
    ADD CONSTRAINT wifistandards_pkey PRIMARY KEY (id);


--
-- TOC entry 3541 (class 2606 OID 19466)
-- Name: components components_country_of_origin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.components
    ADD CONSTRAINT components_country_of_origin_fkey FOREIGN KEY (country_of_origin) REFERENCES public.countries(id);


--
-- TOC entry 3546 (class 2606 OID 19523)
-- Name: cpumanufacturers cpumanufacturers_id_manufacturer_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpumanufacturers
    ADD CONSTRAINT cpumanufacturers_id_manufacturer_fkey FOREIGN KEY (id_manufacturer) REFERENCES public.manufacturers(id);


--
-- TOC entry 3548 (class 2606 OID 19556)
-- Name: cpus cpus_core_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpus
    ADD CONSTRAINT cpus_core_id_fkey FOREIGN KEY (core_id) REFERENCES public.cpucores(id);


--
-- TOC entry 3549 (class 2606 OID 19561)
-- Name: cpus cpus_mem_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpus
    ADD CONSTRAINT cpus_mem_type_id_fkey FOREIGN KEY (mem_type_id) REFERENCES public.ddrtypes(id);


--
-- TOC entry 3550 (class 2606 OID 19551)
-- Name: cpus cpus_socket_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpus
    ADD CONSTRAINT cpus_socket_id_fkey FOREIGN KEY (socket_id) REFERENCES public.cpusockets(id);


--
-- TOC entry 3547 (class 2606 OID 19542)
-- Name: cpusockets cpusockets_id_manufacturer_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpusockets
    ADD CONSTRAINT cpusockets_id_manufacturer_fkey FOREIGN KEY (id_manufacturer) REFERENCES public.cpumanufacturers(id);


--
-- TOC entry 3551 (class 2606 OID 19573)
-- Name: gpumanufacturers gpumanufacturers_id_manufacturer_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gpumanufacturers
    ADD CONSTRAINT gpumanufacturers_id_manufacturer_fkey FOREIGN KEY (id_manufacturer) REFERENCES public.manufacturers(id);


--
-- TOC entry 3552 (class 2606 OID 19585)
-- Name: gpus gpus_id_manufacturer_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gpus
    ADD CONSTRAINT gpus_id_manufacturer_fkey FOREIGN KEY (id_manufacturer) REFERENCES public.gpumanufacturers(id);


--
-- TOC entry 3554 (class 2606 OID 19642)
-- Name: graphiccards graphiccards_connection_interface_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.graphiccards
    ADD CONSTRAINT graphiccards_connection_interface_id_fkey FOREIGN KEY (connection_interface_id) REFERENCES public.pcitypes(id);


--
-- TOC entry 3555 (class 2606 OID 19632)
-- Name: graphiccards graphiccards_gpu_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.graphiccards
    ADD CONSTRAINT graphiccards_gpu_id_fkey FOREIGN KEY (gpu_id) REFERENCES public.gpus(id);


--
-- TOC entry 3556 (class 2606 OID 19627)
-- Name: graphiccards graphiccards_id_manufacturer_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.graphiccards
    ADD CONSTRAINT graphiccards_id_manufacturer_fkey FOREIGN KEY (id_manufacturer) REFERENCES public.graphiccardsmanufacturers(id);


--
-- TOC entry 3557 (class 2606 OID 19637)
-- Name: graphiccards graphiccards_memory_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.graphiccards
    ADD CONSTRAINT graphiccards_memory_type_id_fkey FOREIGN KEY (memory_type_id) REFERENCES public.gddrtypes(id);


--
-- TOC entry 3553 (class 2606 OID 19618)
-- Name: graphiccardsmanufacturers graphiccardsmanufacturers_id_manufacturer_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.graphiccardsmanufacturers
    ADD CONSTRAINT graphiccardsmanufacturers_id_manufacturer_fkey FOREIGN KEY (id_manufacturer) REFERENCES public.manufacturers(id);


--
-- TOC entry 3562 (class 2606 OID 19703)
-- Name: hdd hdd_recording_technology_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hdd
    ADD CONSTRAINT hdd_recording_technology_id_fkey FOREIGN KEY (recording_technology_id) REFERENCES public.rectechhdd(id);


--
-- TOC entry 3540 (class 2606 OID 19454)
-- Name: manufacturers manufacturers_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.manufacturers
    ADD CONSTRAINT manufacturers_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- TOC entry 3565 (class 2606 OID 19747)
-- Name: motherboardmanufacturers motherboardmanufacturers_id_manufacturer_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.motherboardmanufacturers
    ADD CONSTRAINT motherboardmanufacturers_id_manufacturer_fkey FOREIGN KEY (id_manufacturer) REFERENCES public.manufacturers(id);


--
-- TOC entry 3566 (class 2606 OID 19835)
-- Name: motherboards motherboards_audio_chipset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.motherboards
    ADD CONSTRAINT motherboards_audio_chipset_id_fkey FOREIGN KEY (audio_chipset_id) REFERENCES public.audiochipsets(id);


--
-- TOC entry 3567 (class 2606 OID 19850)
-- Name: motherboards motherboards_bluetooth_version_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.motherboards
    ADD CONSTRAINT motherboards_bluetooth_version_fkey FOREIGN KEY (bluetooth_version) REFERENCES public.bluetoothstandards(id);


--
-- TOC entry 3568 (class 2606 OID 19820)
-- Name: motherboards motherboards_chipset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.motherboards
    ADD CONSTRAINT motherboards_chipset_id_fkey FOREIGN KEY (chipset_id) REFERENCES public.motherboardchipsets(id);


--
-- TOC entry 3569 (class 2606 OID 19860)
-- Name: motherboards motherboards_cpu_power_connector_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.motherboards
    ADD CONSTRAINT motherboards_cpu_power_connector_fkey FOREIGN KEY (cpu_power_connector) REFERENCES public.atxconnectors(id);


--
-- TOC entry 3570 (class 2606 OID 19805)
-- Name: motherboards motherboards_form_factor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.motherboards
    ADD CONSTRAINT motherboards_form_factor_id_fkey FOREIGN KEY (form_factor_id) REFERENCES public.motherboardsformfactor(id);


--
-- TOC entry 3571 (class 2606 OID 19810)
-- Name: motherboards motherboards_id_manufacturer_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.motherboards
    ADD CONSTRAINT motherboards_id_manufacturer_fkey FOREIGN KEY (id_manufacturer) REFERENCES public.motherboardmanufacturers(id);


--
-- TOC entry 3572 (class 2606 OID 19855)
-- Name: motherboards motherboards_main_power_connector_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.motherboards
    ADD CONSTRAINT motherboards_main_power_connector_fkey FOREIGN KEY (main_power_connector) REFERENCES public.atxconnectors(id);


--
-- TOC entry 3573 (class 2606 OID 19830)
-- Name: motherboards motherboards_memory_formfactor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.motherboards
    ADD CONSTRAINT motherboards_memory_formfactor_id_fkey FOREIGN KEY (memory_formfactor_id) REFERENCES public.dimmtypes(id);


--
-- TOC entry 3574 (class 2606 OID 19825)
-- Name: motherboards motherboards_memory_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.motherboards
    ADD CONSTRAINT motherboards_memory_type_id_fkey FOREIGN KEY (memory_type_id) REFERENCES public.ddrtypes(id);


--
-- TOC entry 3575 (class 2606 OID 19840)
-- Name: motherboards motherboards_network_adapter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.motherboards
    ADD CONSTRAINT motherboards_network_adapter_id_fkey FOREIGN KEY (network_adapter_id) REFERENCES public.networkadapters(id);


--
-- TOC entry 3576 (class 2606 OID 19815)
-- Name: motherboards motherboards_socket_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.motherboards
    ADD CONSTRAINT motherboards_socket_id_fkey FOREIGN KEY (socket_id) REFERENCES public.cpusockets(id);


--
-- TOC entry 3577 (class 2606 OID 19845)
-- Name: motherboards motherboards_wifi_standard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.motherboards
    ADD CONSTRAINT motherboards_wifi_standard_fkey FOREIGN KEY (wifi_standard) REFERENCES public.wifistandards(id);


--
-- TOC entry 3559 (class 2606 OID 19687)
-- Name: nonvolatilemem nonvolatilemem_form_factor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nonvolatilemem
    ADD CONSTRAINT nonvolatilemem_form_factor_id_fkey FOREIGN KEY (form_factor_id) REFERENCES public.nonvolmemformfact(id);


--
-- TOC entry 3560 (class 2606 OID 19677)
-- Name: nonvolatilemem nonvolatilemem_id_manufacturer_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nonvolatilemem
    ADD CONSTRAINT nonvolatilemem_id_manufacturer_fkey FOREIGN KEY (id_manufacturer) REFERENCES public.nonvolmemmanufacturers(id);


--
-- TOC entry 3561 (class 2606 OID 19682)
-- Name: nonvolatilemem nonvolatilemem_interface_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nonvolatilemem
    ADD CONSTRAINT nonvolatilemem_interface_type_id_fkey FOREIGN KEY (interface_type_id) REFERENCES public.interfacetype(id);


--
-- TOC entry 3558 (class 2606 OID 19654)
-- Name: nonvolmemmanufacturers nonvolmemmanufacturers_id_manufacturer_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nonvolmemmanufacturers
    ADD CONSTRAINT nonvolmemmanufacturers_id_manufacturer_fkey FOREIGN KEY (id_manufacturer) REFERENCES public.manufacturers(id);


--
-- TOC entry 3587 (class 2606 OID 19972)
-- Name: pccases pccases_compatible_motherboard_formfactors_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pccases
    ADD CONSTRAINT pccases_compatible_motherboard_formfactors_fkey FOREIGN KEY (compatible_motherboard_formfactors) REFERENCES public.motherboardsformfactor(id);


--
-- TOC entry 3588 (class 2606 OID 19977)
-- Name: pccases pccases_compatible_power_supply_form_factors_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pccases
    ADD CONSTRAINT pccases_compatible_power_supply_form_factors_fkey FOREIGN KEY (compatible_power_supply_form_factors) REFERENCES public.powersupplyformfactors(id);


--
-- TOC entry 3589 (class 2606 OID 19967)
-- Name: pccases pccases_formfactor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pccases
    ADD CONSTRAINT pccases_formfactor_id_fkey FOREIGN KEY (formfactor_id) REFERENCES public.pccaseformfactors(id);


--
-- TOC entry 3590 (class 2606 OID 19962)
-- Name: pccases pccases_id_manufacturer_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pccases
    ADD CONSTRAINT pccases_id_manufacturer_fkey FOREIGN KEY (id_manufacturer) REFERENCES public.pccasesmanufacturers(id);


--
-- TOC entry 3586 (class 2606 OID 19944)
-- Name: pccasesmanufacturers pccasesmanufacturers_id_manufacturer_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pccasesmanufacturers
    ADD CONSTRAINT pccasesmanufacturers_id_manufacturer_fkey FOREIGN KEY (id_manufacturer) REFERENCES public.manufacturers(id);


--
-- TOC entry 3579 (class 2606 OID 19917)
-- Name: powersupplies powersupplies_cpu_power_connectors_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.powersupplies
    ADD CONSTRAINT powersupplies_cpu_power_connectors_fkey FOREIGN KEY (cpu_power_connectors) REFERENCES public.atxconnectors(id);


--
-- TOC entry 3580 (class 2606 OID 19927)
-- Name: powersupplies powersupplies_fan_size_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.powersupplies
    ADD CONSTRAINT powersupplies_fan_size_id_fkey FOREIGN KEY (fan_size_id) REFERENCES public.fantypes(id);


--
-- TOC entry 3581 (class 2606 OID 19907)
-- Name: powersupplies powersupplies_form_factor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.powersupplies
    ADD CONSTRAINT powersupplies_form_factor_id_fkey FOREIGN KEY (form_factor_id) REFERENCES public.powersupplyformfactors(id);


--
-- TOC entry 3582 (class 2606 OID 19902)
-- Name: powersupplies powersupplies_id_manufacturer_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.powersupplies
    ADD CONSTRAINT powersupplies_id_manufacturer_fkey FOREIGN KEY (id_manufacturer) REFERENCES public.powersupplymanufacturers(id);


--
-- TOC entry 3583 (class 2606 OID 19912)
-- Name: powersupplies powersupplies_main_power_connector_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.powersupplies
    ADD CONSTRAINT powersupplies_main_power_connector_fkey FOREIGN KEY (main_power_connector) REFERENCES public.atxconnectors(id);


--
-- TOC entry 3584 (class 2606 OID 19922)
-- Name: powersupplies powersupplies_pci_e_power_connectors_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.powersupplies
    ADD CONSTRAINT powersupplies_pci_e_power_connectors_fkey FOREIGN KEY (pci_e_power_connectors) REFERENCES public.atxconnectors(id);


--
-- TOC entry 3585 (class 2606 OID 19932)
-- Name: powersupplies powersupplies_protection_technologies_ids_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.powersupplies
    ADD CONSTRAINT powersupplies_protection_technologies_ids_fkey FOREIGN KEY (protection_technologies_ids) REFERENCES public.psuprotectiontechnologies(id);


--
-- TOC entry 3578 (class 2606 OID 19872)
-- Name: powersupplymanufacturers powersupplymanufacturers_id_manufacturer_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.powersupplymanufacturers
    ADD CONSTRAINT powersupplymanufacturers_id_manufacturer_fkey FOREIGN KEY (id_manufacturer) REFERENCES public.manufacturers(id);


--
-- TOC entry 3543 (class 2606 OID 19511)
-- Name: ram ram_form_factor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ram
    ADD CONSTRAINT ram_form_factor_id_fkey FOREIGN KEY (form_factor_id) REFERENCES public.dimmtypes(id);


--
-- TOC entry 3544 (class 2606 OID 19501)
-- Name: ram ram_id_manufacturer_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ram
    ADD CONSTRAINT ram_id_manufacturer_fkey FOREIGN KEY (id_manufacturer) REFERENCES public.rammanufacturers(id);


--
-- TOC entry 3545 (class 2606 OID 19506)
-- Name: ram ram_memory_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ram
    ADD CONSTRAINT ram_memory_type_id_fkey FOREIGN KEY (memory_type_id) REFERENCES public.ddrtypes(id);


--
-- TOC entry 3542 (class 2606 OID 19478)
-- Name: rammanufacturers rammanufacturers_id_manufacturer_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rammanufacturers
    ADD CONSTRAINT rammanufacturers_id_manufacturer_fkey FOREIGN KEY (id_manufacturer) REFERENCES public.manufacturers(id);


--
-- TOC entry 3563 (class 2606 OID 19719)
-- Name: ssd ssd_mem_structure_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ssd
    ADD CONSTRAINT ssd_mem_structure_id_fkey FOREIGN KEY (mem_structure_id) REFERENCES public.ssdmemstruct(id);


--
-- TOC entry 3564 (class 2606 OID 19735)
-- Name: ssdm2 ssdm2_key_m2_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ssdm2
    ADD CONSTRAINT ssdm2_key_m2_id_fkey FOREIGN KEY (key_m2_id) REFERENCES public.ssdm2key(id);


--
-- TOC entry 3738 (class 0 OID 0)
-- Dependencies: 276
-- Name: TABLE atxconnectors; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.atxconnectors TO kirpitcheq;


--
-- TOC entry 3740 (class 0 OID 0)
-- Dependencies: 275
-- Name: SEQUENCE atxconnectors_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.atxconnectors_id_seq TO kirpitcheq;


--
-- TOC entry 3741 (class 0 OID 0)
-- Dependencies: 268
-- Name: TABLE audiochipsets; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.audiochipsets TO kirpitcheq;


--
-- TOC entry 3743 (class 0 OID 0)
-- Dependencies: 267
-- Name: SEQUENCE audiochipsets_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.audiochipsets_id_seq TO kirpitcheq;


--
-- TOC entry 3744 (class 0 OID 0)
-- Dependencies: 274
-- Name: TABLE bluetoothstandards; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.bluetoothstandards TO kirpitcheq;


--
-- TOC entry 3746 (class 0 OID 0)
-- Dependencies: 273
-- Name: SEQUENCE bluetoothstandards_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.bluetoothstandards_id_seq TO kirpitcheq;


--
-- TOC entry 3747 (class 0 OID 0)
-- Dependencies: 219
-- Name: TABLE components; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.components TO kirpitcheq;


--
-- TOC entry 3749 (class 0 OID 0)
-- Dependencies: 218
-- Name: SEQUENCE components_component_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.components_component_id_seq TO kirpitcheq;


--
-- TOC entry 3750 (class 0 OID 0)
-- Dependencies: 215
-- Name: TABLE countries; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.countries TO kirpitcheq;


--
-- TOC entry 3752 (class 0 OID 0)
-- Dependencies: 214
-- Name: SEQUENCE countries_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.countries_id_seq TO kirpitcheq;


--
-- TOC entry 3753 (class 0 OID 0)
-- Dependencies: 230
-- Name: TABLE cpucores; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.cpucores TO kirpitcheq;


--
-- TOC entry 3755 (class 0 OID 0)
-- Dependencies: 229
-- Name: SEQUENCE cpucores_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.cpucores_id_seq TO kirpitcheq;


--
-- TOC entry 3756 (class 0 OID 0)
-- Dependencies: 228
-- Name: TABLE cpumanufacturers; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.cpumanufacturers TO kirpitcheq;


--
-- TOC entry 3758 (class 0 OID 0)
-- Dependencies: 227
-- Name: SEQUENCE cpumanufacturers_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.cpumanufacturers_id_seq TO kirpitcheq;


--
-- TOC entry 3759 (class 0 OID 0)
-- Dependencies: 233
-- Name: TABLE cpus; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.cpus TO kirpitcheq;


--
-- TOC entry 3760 (class 0 OID 0)
-- Dependencies: 232
-- Name: TABLE cpusockets; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.cpusockets TO kirpitcheq;


--
-- TOC entry 3762 (class 0 OID 0)
-- Dependencies: 231
-- Name: SEQUENCE cpusockets_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.cpusockets_id_seq TO kirpitcheq;


--
-- TOC entry 3763 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE ddrtypes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.ddrtypes TO kirpitcheq;


--
-- TOC entry 3765 (class 0 OID 0)
-- Dependencies: 222
-- Name: SEQUENCE ddrtypes_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.ddrtypes_id_seq TO kirpitcheq;


--
-- TOC entry 3766 (class 0 OID 0)
-- Dependencies: 225
-- Name: TABLE dimmtypes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.dimmtypes TO kirpitcheq;


--
-- TOC entry 3768 (class 0 OID 0)
-- Dependencies: 224
-- Name: SEQUENCE dimmtypes_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.dimmtypes_id_seq TO kirpitcheq;


--
-- TOC entry 3769 (class 0 OID 0)
-- Dependencies: 283
-- Name: TABLE fantypes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.fantypes TO kirpitcheq;


--
-- TOC entry 3771 (class 0 OID 0)
-- Dependencies: 282
-- Name: SEQUENCE fantypes_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.fantypes_id_seq TO kirpitcheq;


--
-- TOC entry 3772 (class 0 OID 0)
-- Dependencies: 239
-- Name: TABLE gddrtypes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.gddrtypes TO kirpitcheq;


--
-- TOC entry 3774 (class 0 OID 0)
-- Dependencies: 238
-- Name: SEQUENCE gddrtypes_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.gddrtypes_id_seq TO kirpitcheq;


--
-- TOC entry 3775 (class 0 OID 0)
-- Dependencies: 235
-- Name: TABLE gpumanufacturers; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.gpumanufacturers TO kirpitcheq;


--
-- TOC entry 3777 (class 0 OID 0)
-- Dependencies: 234
-- Name: SEQUENCE gpumanufacturers_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.gpumanufacturers_id_seq TO kirpitcheq;


--
-- TOC entry 3778 (class 0 OID 0)
-- Dependencies: 237
-- Name: TABLE gpus; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.gpus TO kirpitcheq;


--
-- TOC entry 3780 (class 0 OID 0)
-- Dependencies: 236
-- Name: SEQUENCE gpus_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.gpus_id_seq TO kirpitcheq;


--
-- TOC entry 3781 (class 0 OID 0)
-- Dependencies: 246
-- Name: TABLE graphiccards; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.graphiccards TO kirpitcheq;


--
-- TOC entry 3782 (class 0 OID 0)
-- Dependencies: 245
-- Name: TABLE graphiccardsmanufacturers; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.graphiccardsmanufacturers TO kirpitcheq;


--
-- TOC entry 3784 (class 0 OID 0)
-- Dependencies: 244
-- Name: SEQUENCE graphiccardsmanufacturers_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.graphiccardsmanufacturers_id_seq TO kirpitcheq;


--
-- TOC entry 3785 (class 0 OID 0)
-- Dependencies: 241
-- Name: TABLE graphouts; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.graphouts TO kirpitcheq;


--
-- TOC entry 3787 (class 0 OID 0)
-- Dependencies: 240
-- Name: SEQUENCE graphouts_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.graphouts_id_seq TO kirpitcheq;


--
-- TOC entry 3788 (class 0 OID 0)
-- Dependencies: 253
-- Name: TABLE nonvolatilemem; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.nonvolatilemem TO kirpitcheq;


--
-- TOC entry 3789 (class 0 OID 0)
-- Dependencies: 256
-- Name: TABLE hdd; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.hdd TO kirpitcheq;


--
-- TOC entry 3790 (class 0 OID 0)
-- Dependencies: 250
-- Name: TABLE interfacetype; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.interfacetype TO kirpitcheq;


--
-- TOC entry 3792 (class 0 OID 0)
-- Dependencies: 249
-- Name: SEQUENCE interfacetype_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.interfacetype_id_seq TO kirpitcheq;


--
-- TOC entry 3793 (class 0 OID 0)
-- Dependencies: 217
-- Name: TABLE manufacturers; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.manufacturers TO kirpitcheq;


--
-- TOC entry 3795 (class 0 OID 0)
-- Dependencies: 216
-- Name: SEQUENCE manufacturers_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.manufacturers_id_seq TO kirpitcheq;


--
-- TOC entry 3796 (class 0 OID 0)
-- Dependencies: 278
-- Name: TABLE motherboardchipsets; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.motherboardchipsets TO kirpitcheq;


--
-- TOC entry 3798 (class 0 OID 0)
-- Dependencies: 277
-- Name: SEQUENCE motherboardchipsets_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.motherboardchipsets_id_seq TO kirpitcheq;


--
-- TOC entry 3799 (class 0 OID 0)
-- Dependencies: 264
-- Name: TABLE motherboardmanufacturers; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.motherboardmanufacturers TO kirpitcheq;


--
-- TOC entry 3801 (class 0 OID 0)
-- Dependencies: 263
-- Name: SEQUENCE motherboardmanufacturers_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.motherboardmanufacturers_id_seq TO kirpitcheq;


--
-- TOC entry 3802 (class 0 OID 0)
-- Dependencies: 279
-- Name: TABLE motherboards; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.motherboards TO kirpitcheq;


--
-- TOC entry 3803 (class 0 OID 0)
-- Dependencies: 266
-- Name: TABLE motherboardsformfactor; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.motherboardsformfactor TO kirpitcheq;


--
-- TOC entry 3805 (class 0 OID 0)
-- Dependencies: 265
-- Name: SEQUENCE motherboardsformfactor_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.motherboardsformfactor_id_seq TO kirpitcheq;


--
-- TOC entry 3806 (class 0 OID 0)
-- Dependencies: 270
-- Name: TABLE networkadapters; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.networkadapters TO kirpitcheq;


--
-- TOC entry 3808 (class 0 OID 0)
-- Dependencies: 269
-- Name: SEQUENCE networkadapters_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.networkadapters_id_seq TO kirpitcheq;


--
-- TOC entry 3809 (class 0 OID 0)
-- Dependencies: 252
-- Name: TABLE nonvolmemformfact; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.nonvolmemformfact TO kirpitcheq;


--
-- TOC entry 3811 (class 0 OID 0)
-- Dependencies: 251
-- Name: SEQUENCE nonvolmemformfact_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.nonvolmemformfact_id_seq TO kirpitcheq;


--
-- TOC entry 3812 (class 0 OID 0)
-- Dependencies: 248
-- Name: TABLE nonvolmemmanufacturers; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.nonvolmemmanufacturers TO kirpitcheq;


--
-- TOC entry 3814 (class 0 OID 0)
-- Dependencies: 247
-- Name: SEQUENCE nonvolmemmanufacturers_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.nonvolmemmanufacturers_id_seq TO kirpitcheq;


--
-- TOC entry 3815 (class 0 OID 0)
-- Dependencies: 292
-- Name: TABLE pccaseformfactors; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.pccaseformfactors TO kirpitcheq;


--
-- TOC entry 3817 (class 0 OID 0)
-- Dependencies: 291
-- Name: SEQUENCE pccaseformfactors_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.pccaseformfactors_id_seq TO kirpitcheq;


--
-- TOC entry 3818 (class 0 OID 0)
-- Dependencies: 293
-- Name: TABLE pccases; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.pccases TO kirpitcheq;


--
-- TOC entry 3819 (class 0 OID 0)
-- Dependencies: 290
-- Name: TABLE pccasesmanufacturers; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.pccasesmanufacturers TO kirpitcheq;


--
-- TOC entry 3821 (class 0 OID 0)
-- Dependencies: 289
-- Name: SEQUENCE pccasesmanufacturers_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.pccasesmanufacturers_id_seq TO kirpitcheq;


--
-- TOC entry 3822 (class 0 OID 0)
-- Dependencies: 243
-- Name: TABLE pcitypes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.pcitypes TO kirpitcheq;


--
-- TOC entry 3824 (class 0 OID 0)
-- Dependencies: 242
-- Name: SEQUENCE pcitypes_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.pcitypes_id_seq TO kirpitcheq;


--
-- TOC entry 3825 (class 0 OID 0)
-- Dependencies: 288
-- Name: TABLE powersupplies; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.powersupplies TO kirpitcheq;


--
-- TOC entry 3826 (class 0 OID 0)
-- Dependencies: 285
-- Name: TABLE powersupplyformfactors; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.powersupplyformfactors TO kirpitcheq;


--
-- TOC entry 3828 (class 0 OID 0)
-- Dependencies: 284
-- Name: SEQUENCE powersupplyformfactors_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.powersupplyformfactors_id_seq TO kirpitcheq;


--
-- TOC entry 3829 (class 0 OID 0)
-- Dependencies: 281
-- Name: TABLE powersupplymanufacturers; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.powersupplymanufacturers TO kirpitcheq;


--
-- TOC entry 3831 (class 0 OID 0)
-- Dependencies: 280
-- Name: SEQUENCE powersupplymanufacturers_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.powersupplymanufacturers_id_seq TO kirpitcheq;


--
-- TOC entry 3832 (class 0 OID 0)
-- Dependencies: 287
-- Name: TABLE psuprotectiontechnologies; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.psuprotectiontechnologies TO kirpitcheq;


--
-- TOC entry 3834 (class 0 OID 0)
-- Dependencies: 286
-- Name: SEQUENCE psuprotectiontechnologies_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.psuprotectiontechnologies_id_seq TO kirpitcheq;


--
-- TOC entry 3835 (class 0 OID 0)
-- Dependencies: 226
-- Name: TABLE ram; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.ram TO kirpitcheq;


--
-- TOC entry 3836 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE rammanufacturers; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.rammanufacturers TO kirpitcheq;


--
-- TOC entry 3838 (class 0 OID 0)
-- Dependencies: 220
-- Name: SEQUENCE rammanufacturers_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.rammanufacturers_id_seq TO kirpitcheq;


--
-- TOC entry 3839 (class 0 OID 0)
-- Dependencies: 255
-- Name: TABLE rectechhdd; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.rectechhdd TO kirpitcheq;


--
-- TOC entry 3841 (class 0 OID 0)
-- Dependencies: 254
-- Name: SEQUENCE rectechhdd_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.rectechhdd_id_seq TO kirpitcheq;


--
-- TOC entry 3842 (class 0 OID 0)
-- Dependencies: 259
-- Name: TABLE ssd; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.ssd TO kirpitcheq;


--
-- TOC entry 3843 (class 0 OID 0)
-- Dependencies: 262
-- Name: TABLE ssdm2; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.ssdm2 TO kirpitcheq;


--
-- TOC entry 3844 (class 0 OID 0)
-- Dependencies: 261
-- Name: TABLE ssdm2key; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.ssdm2key TO kirpitcheq;


--
-- TOC entry 3846 (class 0 OID 0)
-- Dependencies: 260
-- Name: SEQUENCE ssdm2key_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.ssdm2key_id_seq TO kirpitcheq;


--
-- TOC entry 3847 (class 0 OID 0)
-- Dependencies: 258
-- Name: TABLE ssdmemstruct; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.ssdmemstruct TO kirpitcheq;


--
-- TOC entry 3849 (class 0 OID 0)
-- Dependencies: 257
-- Name: SEQUENCE ssdmemstruct_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.ssdmemstruct_id_seq TO kirpitcheq;


--
-- TOC entry 3850 (class 0 OID 0)
-- Dependencies: 272
-- Name: TABLE wifistandards; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.wifistandards TO kirpitcheq;


--
-- TOC entry 3852 (class 0 OID 0)
-- Dependencies: 271
-- Name: SEQUENCE wifistandards_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.wifistandards_id_seq TO kirpitcheq;


-- Completed on 2024-05-08 16:27:48 MSK

--
-- PostgreSQL database dump complete
--

