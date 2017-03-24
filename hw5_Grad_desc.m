clear
clc

u = 1;
v = 1;
eta = 0.1;
it=0;

error = (u*exp(v)-2*v*exp(-u))^2;

while error>=10^(-14)
    du_error = 2*(exp(v)+2*v*exp(-u))*(u*exp(v)-2*v*exp(-u));
    dv_error = 2*(u*exp(v)-2*exp(-u))*(u*exp(v)-2*v*exp(-u));
    u=u-eta*du_error;
    v=v-eta*dv_error;
    error = (u*exp(v)-2*v*exp(-u))^2;
    it=it+1;
end

it
u
v