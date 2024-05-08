CREATE TABLE Countries(
    id SERIAL PRIMARY KEY,
    name VARCHAR(100)
);
CREATE TABLE Manufacturers(
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    country_id INT REFERENCES Countries(id)
);
-- Создание таблицы "Комплектующие"
CREATE TABLE Components (
    component_id SERIAL PRIMARY KEY,
    price int,
    model VARCHAR(100),
    manufacturer_code VARCHAR(50),
    country_of_origin int REFERENCES Countries(id),
    release_year INTEGER,
    width_mm DECIMAL(6, 2),
    length_mm DECIMAL(6, 2),
    thickness_mm DECIMAL(6, 2),
    weight_g INTEGER,

    description VARCHAR(100)
);

-- Создание таблицы "Оперативная память"
CREATE TABLE RAMManufacturers(
    id SERIAL PRIMARY KEY,
    id_manufacturer INT REFERENCES Manufacturers(id)
);
CREATE TABLE DDRTypes(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    speed_mhz INT
);
CREATE TABLE DIMMTypes(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);
CREATE TABLE RAM (
    id_manufacturer INT REFERENCES RAMManufacturers(id),
    memory_type_id int REFERENCES DDRTypes(id),
    form_factor_id int REFERENCES DIMMTypes(id),
    modules_count INT,
    memory_mb INT,
    voltage FLOAT,
    frequency_mhz INT
) INHERITS(Components);

-- Создание таблицы "Процессоры"
CREATE TABLE CPUManufacturers(
    id SERIAL PRIMARY KEY,
    id_manufacturer INT REFERENCES Manufacturers(id)
);
CREATE TABLE CPUCores (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);
CREATE TABLE CPUSockets(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    id_manufacturer int REFERENCES CPUManufacturers(id)
);
CREATE TABLE CPUs (

    socket_id INT REFERENCES CPUSockets(id),
    --cores
    cores_count INT,
    threads_count INT,
    cache_l2_mb int,
    cache_l3_mb int,
    technology_process_nm int,
    core_id INT REFERENCES CPUCores(id),
    -- speed
    base_clock_speed FLOAT,
    max_turbo_clock_speed FLOAT,
    unlocked_multiplier BOOLEAN,
    -- ram compatibility
    mem_type_id INT REFERENCES DDRTypes(id),
    max_supported_memory_mb INT,
    memory_channels INT,
    memory_frequency_hz INT,
    ecc_support BOOLEAN,

    tdp_watt INTEGER,
    base_tdp_watt INTEGER,
    max_cpu_temp FLOAT,

    integrated_graphics BOOLEAN,

    integrated_pci_express_controller BOOLEAN,
    pci_express_lanes INTEGER,

    virtualization_technology BOOLEAN
) INHERITS(Components);


-- Создание таблицы "Графические карты"
CREATE TABLE GPUManufacturers(
    id SERIAL PRIMARY KEY,
    id_manufacturer INT REFERENCES Manufacturers(id)
);
CREATE TABLE GPUs(
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    id_manufacturer int REFERENCES GPUManufacturers(id),
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
);
CREATE TABLE GDDRTypes(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);
CREATE TABLE GraphOuts(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);
CREATE TABLE PCITypes(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);
CREATE TABLE GraphicCardsManufacturers(
    id SERIAL PRIMARY KEY,
    id_manufacturer INT REFERENCES Manufacturers(id)
);
CREATE TABLE GraphicCards(
    id_manufacturer int REFERENCES GraphicCardsManufacturers(id),

    mining_purpose BOOLEAN,
    lhr BOOLEAN,

    gpu_id INT REFERENCES GPUs(id),

    memory_capacity INT,
    memory_type_id INT REFERENCES GDDRTypes(id),
    memory_bus_width INT,
    memory_bandwidth INT,
    memory_clock_speed_mhz INT,

    simultaneous_monitors_count INTEGER,
    max_resolution VARCHAR(20),

    connection_interface_id INTEGER REFERENCES PCITypes(id),
    pci_express_lines INTEGER,
    additional_power_connectors BOOLEAN,
    recommended_power_supply INTEGER,

    cooling_fan_count INTEGER,
    liquid_cooling_radiator BOOLEAN,

    low_profile BOOLEAN
) INHERITS(Components);

-- Создание таблиц "Энергонезависимая память"
CREATE TABLE NonVolMemManufacturers(
    id SERIAL PRIMARY KEY,
    id_manufacturer INT REFERENCES Manufacturers(id)
);
CREATE TABLE InterfaceType(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    interface_throughput_gbps DECIMAL(4, 2)
);
CREATE TABLE NonVolMemFormfact(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);
CREATE TABLE NonVolatileMem (
    id_manufacturer int REFERENCES NonVolMemManufacturers(id),
    capacity_mb INT,
    interface_type_id INT REFERENCES InterfaceType(id),
    form_factor_id INT REFERENCES NonVolMemFormfact(id)
) INHERITS(Components);
CREATE TABLE RecTechHDD(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE HDD (
    volume_gb INTEGER,
    cache_mb INTEGER,
    spindle_speed INTEGER,
    max_data_transfer_speed_mbps INTEGER,
    latency_ms DECIMAL(4, 2),
    raid_optimization BOOLEAN,

    recording_technology_id int REFERENCES RecTechHDD(id),

    operating_shock_resistance_g DECIMAL(4, 2),
    operating_noise_level_db DECIMAL(4, 2),
    idle_noise_level_db DECIMAL(4, 2),
    helium_filled BOOLEAN,
    positioning_parking_cycles INTEGER,

    max_power_consumption_w DECIMAL(4, 2),
    idle_power_consumption_w DECIMAL(4, 2),
    max_operating_temperature_c INTEGER
) INHERITS(NonVolatileMem);
-- Создание таблицы "SSD"
CREATE TABLE SSDMemStruct(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    cell_bits VARCHAR(10)
);

CREATE TABLE SSD (
    mem_structure_id int REFERENCES SSDMemStruct(id),

    max_sequential_read_speed_mbps INTEGER,
    max_sequential_write_speed_mbps INTEGER,
    max_write_endurance_tb INTEGER,
    hardware_encryption BOOLEAN
) INHERITS(NonVolatileMem);

CREATE TABLE SSDM2Key(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    cell_bits VARCHAR(10)
);

CREATE TABLE SSDM2 (
    key_m2_id INT REFERENCES SSDM2Key(id),
    nvme BOOLEAN
) INHERITS(SSD);

-- Создание таблицы "Материнские платы"
CREATE TABLE MotherboardManufacturers(
    id SERIAL PRIMARY KEY,
    id_manufacturer INT REFERENCES Manufacturers(id)
);
CREATE TABLE MotherboardsFormFactor(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);
CREATE TABLE AudioChipsets(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);
CREATE TABLE NetworkAdapters(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);
CREATE TABLE WifiStandards(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);
CREATE TABLE BluetoothStandards(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);
CREATE TABLE ATXConnectors(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);
CREATE TABLE MotherboardChipsets(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);
CREATE TABLE Motherboards (
    form_factor_id INT REFERENCES MotherboardsFormFactor(id),
    id_manufacturer int REFERENCES MotherboardManufacturers(id),

    compatible_cpu_cores VARCHAR(100),
    socket_id INT REFERENCES CPUSockets(id),
    chipset_id INT REFERENCES MotherboardChipsets(id),

    memory_type_id INT REFERENCES DDRTypes(id),
    memory_formfactor_id INT REFERENCES DIMMTypes(id),
    mem_slots INT,
    memory_channels INT,
    max_memory_gb INT,
    max_memory_speed_mhz INT,

    pci_slots int,
    sli_crossfire_support BOOLEAN,

    nvme_support BOOLEAN,
    m2_slots INTEGER,
    m2_e_slots INTEGER,

    sata_ports INTEGER,
    sata_raid_support BOOLEAN,
    ide_ports INTEGER,
    usb_2_count INTEGER, 
    usb_3_count INTEGER,
    usb_type_a_ports INTEGER,
    usb_type_c_ports INTEGER,
    vga_ports INTEGER,
    rj45_ports INTEGER,
    analog_audio_ports INTEGER,
    spdif_ports BOOLEAN,
    sma_ports BOOLEAN,
    ps2_ports BOOLEAN,
    internal_usb_type_a_ports INTEGER,
    internal_usb_type_c_ports INTEGER,

    cpu_cooler_power_pin INTEGER,
    case_fan_3pin_ports INTEGER,
    case_fan_4pin_ports INTEGER,

    argb_fan_ports BOOLEAN,
    rgb_fan_ports BOOLEAN,

    rs232_com_ports BOOLEAN,
    lpt_interface BOOLEAN,
    audio_chipset_id INT REFERENCES AudioChipsets(id),

    network_speed_gbps DECIMAL(3,1),
    network_adapter_id INT REFERENCES NetworkAdapters(id),

    wifi_standard INT REFERENCES WifiStandards(id),
    bluetooth_version INT REFERENCES BluetoothStandards(id),
    main_power_connector INT REFERENCES ATXConnectors(id),
    cpu_power_connector INT REFERENCES ATXConnectors(id),
    power_phase_count INTEGER,
    chipset_passive_cooling BOOLEAN,
    chipset_active_cooling BOOLEAN,

    onboard_buttons BOOLEAN,
    onboard_lighting BOOLEAN,
    lighting_sync_software BOOLEAN
) INHERITS(Components);

