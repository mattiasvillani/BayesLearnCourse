theta = linspace(0.001,0.999,1000);
fontSize = 24;

figure
n = 10; s = 4;
plot(theta, theta.^s.*(1-theta).^(n-s), 'linewidth',3)
xlabel('\theta','fontsize',fontSize)
ylabel('\theta^s(1-\theta)^f','fontsize',fontSize)
set(gca,'ytick',[])
title('n = 10,  s = 4','fontsize',fontSize)
box off
print BernLike_n10s4 -depsc2

figure
n = 100; s = 40;
plot(theta, theta.^s.*(1-theta).^(n-s), 'linewidth',3)
xlabel('\theta','fontsize',fontSize)
ylabel('\theta^s(1-\theta)^f','fontsize',fontSize)
set(gca,'ytick',[])
title('n = 100,  s = 40','fontsize',fontSize)
box off
print BernLike_n100s40 -depsc2

figure
n = 10; s = 9;
plot(theta, theta.^s.*(1-theta).^(n-s), 'linewidth',3)
xlabel('\theta','fontsize',fontSize)
ylabel('\theta^s(1-\theta)^f','fontsize',fontSize)
set(gca,'ytick',[])
title('n = 10,  s = 9','fontsize',fontSize)
box off
print BernLike_n10s9 -depsc2


figure
n = 10; s = 9;
likelihood = theta.^s.*(1-theta).^(n-s);
plot(theta, likelihood, 'linewidth',3)
xlabel('\theta','fontsize',fontSize)
ylabel('\theta^s(1-\theta)^f','fontsize',fontSize)
set(gca,'ytick',[])
title('n = 10,  s = 9','fontsize',fontSize)
box off
hold on
index = theta<0.6;
handle = patch([theta(index),fliplr(theta(index))],[0*theta(index),fliplr(likelihood(index))],[0 0 1], 'facealpha',0.2, 'edgecolor','none');
plot(theta, likelihood, 'linewidth',3, 'color','b')
text(0.3,0.01,'Pr(\theta < 0.6 | data)','fontsize',16)

print BernLikeIntegrateTail -depsc2