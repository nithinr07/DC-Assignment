function [] = channel_modeling()
    d = 200:100:1000;
    mu = 1;
    sigma = 6;
    P_t = 10;
    f = 900 * 10^6;
    lambda = 3*(10^8) / f;
    G_trans = 5;
    G_recv = 4;
    G = G_trans + G_recv;
    d_o = 1;
    gamma = 3;
    K = 20*log10(lambda/(4*pi*d_o)) + G;
    P_min = -110;
    P_out = zeros(length(d), 1);
    for i=1:length(d)
        P_out(i) = outage_probability(K, gamma, d(i), d_o, P_t, P_min, mu, sigma);
    end
     figure(1);
     semilogy(d, P_out);
     hold on;
     P_out = zeros(length(d), 1);
     for i=1:length(d)
        P_out(i) = outage_probability_analytical(K, gamma, d(i), d_o, P_t, P_min, mu, sigma);
     end
%      figure(2);
     semilogy(d, P_out);
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     mu = 1;
     sigma = 9;
     P_out = zeros(length(d), 1);
     for i=1:length(d)
        P_out(i) = outage_probability(K, gamma, d(i), d_o, P_t, P_min, mu, sigma);
     end
     figure(2);
     semilogy(d, P_out);
     hold on;
     P_out = zeros(length(d), 1);
     for i=1:length(d)
        P_out(i) = outage_probability_analytical(K, gamma, d(i), d_o, P_t, P_min, mu, sigma);
     end
     semilogy(d, P_out);
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     mu = 5;
     sigma = 9;
     P_out = zeros(length(d), 1);
     for i=1:length(d)
        P_out(i) = outage_probability(K, gamma, d(i), d_o, P_t, P_min, mu, sigma);
     end
     figure(2);
     semilogy(d, P_out);
     hold on;
     P_out = zeros(length(d), 1);
     for i=1:length(d)
        P_out(i) = outage_probability_analytical(K, gamma, d(i), d_o, P_t, P_min, mu, sigma);
     end
     semilogy(d, P_out);
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     mu = 1;
     sigma = 6;
     radius = 300;
     Pr = received_power(K, gamma, radius, d_o, P_t, mu, sigma);
end

function [Pr] = received_power(K, gamma, d, d_o, P_t, mu, sigma)
    Pr = K - (10*gamma*log10(d/d_o)) + normrnd(mu, sigma) + P_t;
end

function [P_out] = outage_probability(K, gamma, d, d_o, P_t, P_min, mu, sigma)
    count = 0;
    for i = 1:10^6
        Pr = received_power(K, gamma, d, d_o, P_t, mu, sigma);
        if Pr<P_min
            count = count + 1;
        end
    end
    P_out = count/10^6;
end

function [P_out] = outage_probability_analytical(K, gamma, d, d_o, P_t, P_min, mu, sigma)
    x = (P_t + K - (10*gamma*log10(d/d_o)) - P_min - mu) / sigma;
    P_out = qfunc(x);
end