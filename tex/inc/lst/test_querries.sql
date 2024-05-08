select add_rams();
select add_cpus();
select add_gcards();
select add_hdds();
select add_ssds();
select add_ssdsm2();
select add_motherboards();

select * from components as c join ram on c.component_id=ram.component_id;
select * from components as c join cpus on c.component_id=cpus.component_id;
select * from components as c join graphiccards as gc on c.component_id=gc.component_id;
select * from components as c join hdd on c.component_id=hdd.component_id;
select * from components as c join ssd on c.component_id=ssd.component_id;
select * from components as c join ssdm2 on c.component_id=ssdm2.component_id;

select * from components as c join nonvolatilemem as nvm on c.component_id=nvm.component_id;

select * from components as c join motherboards as mb on c.component_id=mb.component_id;

select * from components;

select * from countries;

select * from ddrtypes;

select * from cpusockets;

select * from manufacturers;

select * from gpus;

