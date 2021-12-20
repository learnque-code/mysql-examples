-- Exercise 1
CREATE INDEX idx_nc_name ON Friends(Name DESC);
DROP INDEX IF EXISTS idx_nc_name ON Friends;

CREATE INDEX idx_nc_city ON Friends(City ASC);
DROP INDEX IF EXISTS idx_nc_city ON Friends;

create index idx_nc_city
    on Customers (city);

create index idx_nc_companyname
    on Customers (companyname);

create index idx_nc_postalcode
    on Customers (postalcode);

create index idx_nc_region
    on Customers (region);

-- Exercise 2

