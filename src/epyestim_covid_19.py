import os

import epyestim
import epyestim.covid19 as covid19
import matplotlib.pyplot as plt
import pandas as pd
from scipy.stats import gamma

# plt.style.use('seaborn-white')

ch_cases = pd.read_csv(
    os.path.join('..', 'data', 'CH_covid_cases_reported.csv'),
    parse_dates=['Date']
).set_index('Date')['Cases']

print(ch_cases)

# serial interval distribution
si_distrb = covid19.generate_standard_si_distribution()
# delay distribution
delay_distrb = covid19.generate_standard_infection_to_reporting_distribution()

fig, axs = plt.subplots(1, 2, figsize=(12, 3))

axs[0].bar(range(len(si_distrb)), si_distrb, width=1)
axs[1].bar(range(len(delay_distrb)), delay_distrb, width=1)

axs[0].set_title('Default serial interval distribution')
axs[1].set_title('Default infection-to-reporting delay distribution')
plt.show()

# One way to make your own distributions is to pick a standard continuous distribution
# from the scipy.stats package (an object of type rv_continuous) and discretise it by
# using our function epyestim.discrete_distrb()
my_continuous_distrb = gamma(a=5, scale=2)
my_discrete_distrb = epyestim.discrete_distrb(my_continuous_distrb)

plt.bar(range(len(my_discrete_distrb)), my_discrete_distrb, width=1)
plt.show()

# estimate the time-varying effective reproduction number R(t) for Switzerland,
# using our default distributions and parameters
ch_time_varying_r = covid19.r_covid(ch_cases)

print(ch_time_varying_r.head())

# plot the time-varying reproduction number for Switzerland
fig, ax = plt.subplots(1, 1, figsize=(12, 4))

ch_time_varying_r.loc[:, 'Q0.5'].plot(ax=ax, color='red')
ax.fill_between(ch_time_varying_r.index,
                ch_time_varying_r['Q0.025'],
                ch_time_varying_r['Q0.975'],
                color='red', alpha=0.2)
ax.set_xlabel('date')
ax.set_ylabel('R(t) with 95%-CI')
ax.set_ylim([0, 3])
ax.axhline(y=1)
ax.set_title('Estimate of time-varying effective reproduction number for Switzerland')
plt.show()
