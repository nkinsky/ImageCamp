function [mu,SEM] = corr_cdfs(r,r_shuf,sesh1,sesh2)
%[mu,SEM] = corr_cdfs(r,r_shuf,sesh1,sesh2)
%
%   Plots the CDF of the empirical R values found for each neuron when
%   comparing two sessions. Also plots a shuffled CDF of R values for
%   within-session shuffled neurons. 
%
%   INPUTS: 
%       r: SxSxN correlation matrix from pairwise_corr.m. 
%
%       r_shuf: SxSxNxB correlation matrix from pairwise_corr.m. 
%
%       sesh1 & sesh2: numbers indicating which sessions you want to
%       compare. 
%
%   OUTPUTS: 
%       mu: Nx1 vector containing the means of the correlation coefficients
%       between the specified sessions across the permutation iterations.
%
%       SEM: Nx1 vector containing the standard errors from the mean for
%       each associated correlation coefficient. 
%

%% Useful parameters. 
    B = size(r,3);              %Number of permutations. 

%% Find the stats of the shuffled cell correlations. 
    mu = squeeze(nanmean(r_shuf(sesh1,sesh2,:,:),4));               %Take the mean along the permutation iteration dimension.
    SEM = squeeze(nanstd(r_shuf(sesh1,sesh2,:,:),[],4))/sqrt(B);    %Find the SEM along the same dimension
    CI_l = mu-1.96*SEM;                                             %Confidence intervals. 
    Cl_u = mu+1.96*SEM; 
    
%% Find CDF of the empirical distribution of correlations across neurons. 
    comp_r = squeeze(r(sesh1,sesh2,:)); 
    
%% Plot CDFs. 
    [mu_p,mu_x] = ecdf(mu);                 
    [mu_p_l,mu_x_l] = ecdf(CI_l);
    [mu_p_u,mu_x_u] = ecdf(Cl_u);
    [comp_r_p,comp_r_x] = ecdf(comp_r); 
    
    figure;
        hold on;
        plot(mu_x,mu_p, 'b');                               %Mean across bootstraps
        plot(mu_x_l,mu_p_l, 'b--', mu_x_u,mu_p_u,'b--');    %+/- 1.96 SEM across bootstraps
        plot(comp_r_x,comp_r_p,'k');                        %Empirical, nonshuffled
        hold off;
        
        title('Cumulative Distribution of Correlation Coefficients', 'fontsize', 12); 
        xlabel('R values', 'fontsize', 12); 
        ylabel('Proportion', 'fontsize', 12); 
        set(gca, 'ticklength', [0 0]); 
end