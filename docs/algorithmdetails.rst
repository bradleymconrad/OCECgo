#################
Algorithm Details
#################

.. contents::
  :depth: 2
  :local:

************
Introduction
************

Novel features of the *OCECgo* software tool's algorithm are briefly presented here.

****************************************
Monte Carlo Analysis of Calibration Data
****************************************

As discussed by Conrad & Johnson [1]_, the Sunset Laboratory Model 4 instrument performs an in-test calibration at the end of each thermal analysis. A known volume of a 5% methane-helium mixture is introduced into the instrument, evolved into carbon dioxide, and measured by the NDIR. The integrated NDIR signal during this in-test calibration (the CH\ :sub:`4`\ -loop) corresponds to the known mass of injected carbon (in methane) and is therefore a means to quantify the NDIR sensitivity during the test. This NDIR sensitivity is then coupled with the NDIR signal during the sample analysis phases to quantify organic (OC) and elemental carbon (EC) in the sample. The injected mass of the methane-helium mixture however, is sensitive to operating conditions and can vary in time; consequently, it must be calibrated with some frequency (monthly calibrations are recommended by the manufacturer).

Calibrating CH\ :sub:`4`\ -Loop Carbon Mass
===============================================

Calibration of carbon mass injected during the CH\ :sub:`4`\ -loop is accomplished using use of an external standard. An aqueous sucrose solution of known concentration is introduced to the instrument. A thermal analysis is then performed to obtain the integrated NDIR signal during the analysis ("total area", :math:`x_i`) corresponding to a known carbon mass (:math:`y_i`) in sucrose, as well as the integrated NDIR signal during the CH\ :sub:`4`\ -loop ("calibration area", :math:`c_i`). This procedure is repeated :math:`I` times (i.e., :math:`i \in \left\{ 1...I \right\}`) with three different volumes of injected sucrose: 0, 5, and 10 μL. The injected carbon mass during the CH\ :sub:`4`\ -loop is then quantified by performing a linear regression of :math:`x` and :math:`y` and computing the value of :math:`y` corresponding to the mean of the calibration areas (:math:`\overline{c_i}`). In summary, the linear regression estimates the mean sensitivity of the NDIR detector (total area vs. carbon mass) and the mean calibration area is substituted to estimate the actual injected mass of carbon in the CH\ :sub:`4`\ -loop.

Uncertainty in Calibration
==========================

There are numerous sources of error in this calibration procedure:

  * Uncertainty in the sucrose solution's concentration of carbon, affecting :math:`y_i`.

  * Uncertainty in the introduction of desired volumes of the solution into the instrument (via pipette), affecting :math:`y_i`.

  * Bias in the NDIR detector, affecting :math:`x_i` and :math:`c_i`.

  * Uncertainties associated with linear regression, affecting the calibrated carbon mass (:math:`m_C`).

The *OCECgo* software employes a Monte Carlo method (MCM) to propagate these sources of error into the computation of the CH\ :sub:`4`\ -loop carbon mass. Refer to the :ref:`calibration tool <AnchorToCalibrationMCM>` for a detailed description of user inputs.

*OCECgo* Monte Carlo Method for Calibration
===========================================

Uncertainty in Total Area of Each Data (:math:`x_i`)
----------------------------------------------------

Uncertainty in the total area from the thermal analysis of each sucrose-laden sample is quantified with the bias of the NDIR detector. The NDIR bias is estimated from the :math:`I` calibration areas by assuming that the actual injected carbon mass during the CH\ :sub:`4`\ -loop is constant over the acquisition of calibration data and variance in the reported calibration areas are a function of NDIR bias alone. Mathematically, the relative bias of the NDIR detector is:

  .. math::

    b_{NDIR} = \frac{s_c}{\overline{c_i}}

where :math:`s_c` represents the standard deviation of the :math:`c_i`.

Within the MCM, the j\ :sup:`th` random draw of :math:`x_i` (:math:`= x_{i,j}`) is:

  .. math::

    x_{i,j} = \left( 1 + \xi_j \right) * x_i

and:

  .. math::

    \xi_j \sim \mathcal{N} \left( 0, b_{NDIR} \right)

where :math:`\mathcal{N} \left( \mu,\sigma \right)` is a normal distribution.

Uncertainty in Mean Calibration Area (:math:`\overline{c_i}`)
-------------------------------------------------------------

Within the MCM, the  j\ :sup:`th` random draw of :math:`\overline{c_i}` (:math:`= C_j`) is quantified using the distribution of the mean. Since this is affected by **bias**, the random variable from above is necessarily used:

  .. math::

    C_j = \left( 1 + \frac{\xi_j}{\sqrt{I}} \right) * \overline{c_i}

where the term :math:`\sqrt{I}` implies that this is a distribution of the mean.

Uncertainty in Applied Carbon in Sucrose (:math:`y_i`)
------------------------------------------------------

Uncertainty in the applied carbon in sucrose is quantified in a two-step procedure. For the j\ :sup:`th` random draw:

  1. The mass concentration of sucrose-bound carbon in the aqueous solution is estimated:

    a. The mass fraction of sucrose in the solution is estimated using the nominal sucrose and water masses, while considering bias in the scale used to measure the masses and uncertainty in the purity of the sucrose.

    b. The density of the solution (sensitive to ambient temperature and composition of the solution) is quantified using the empirical model of Darros-Barbosa *et al.* [2]_.

    c. The carbon fraction of sucrose (42.11% carbon) is used to obtain the mass of carbon per unit volume of sucrose solution.

  2. Depending on the volume of solution applied for the specific calibration data, pipette uncertainty (bias and precision) are applied to the solution volume. Solution volume is then multiplied with the carbon fraction of sucrose (1c) to obtain a Monte Carlo-estimate of :math:`y_{i,j}`.

Uncertainty Propagation through Regression
------------------------------------------

When propagating the uncertainties of :math:`x_i`, :math:`y_i`, and :math:`c_i` through the linear regression to obtain the CH\ :sub:`4`\ -loop carbon mass, two sources of error need to be considered:

  1. Nominal uncertainty in the regression - i.e., the prediction interval of the regression.

  2. Regression uncertainty due to uncertainty of the regressed data.

Within *OCECgo*, the former is handled using typical techniques for linear regression of the **nominal** (i.e., not Monte Carlo-perturbed) values of :math:`x_i` and :math:`y_i`. This yields standard errors of the slope and intercept - :math:`\mathrm{se}_{\beta_{0,1}}` and :math:`\mathrm{se}_{\beta_{1,1}}`, respectively - where, for :math:`\beta_{m,n}`, :math:`m \in \left\{ 0,1 \right\}` corresponds to the regression slope (0) and intercept (1), and :math:`n \in \left\{ 1,2 \right\}` corresponds to the above-listed sources of error.

Standard errors of the slope and intercept due to uncertainty of the regressed data (error source 2) are estimated via the MCM. This is accomplished by performing a linear fit to the dataset corresponding to the j\ :sup:`th` Monte Carlo draw. That is, the j\ :sup:`th` Monte Carlo-estimate of slope and intercept (:math:`\beta_{0,2,j}` and :math:`\beta_{1,2,j}`) are obtained from regression of :math:`\left\{ x_{i,j} \right\}` and :math:`\left\{ y_{i,j} \right\}` in the i\ :sup:`th` dimension. This yields, for :math:`J` total Monte Carlo draws, :math:`J \times 1` vectors of slope and intercept from which the standard errors are computed:

  .. math::

    {\begin{array}{cccc} \mathrm{se}_{\beta_{0, 2}} = \frac{s_{\beta_{0,2}}}{\sqrt{J}} & & & \mathrm{se}_{\beta_{1, 2}} = \frac{s_{\beta_{1,2}}}{\sqrt{J}} \end{array}}

Total standard errors of the regression slope and intercept are then computed by summing these two sources in quadrature:

  .. math::

    {\begin{array}{cccc} \mathrm{se}_{\beta_{0}} = \sqrt{\mathrm{se}_{\beta_{0,1}}^2 + \mathrm{se}_{\beta_{0,2}}^2} & & & \mathrm{se}_{\beta_{1}} = \sqrt{\mathrm{se}_{\beta_{1,1}}^2 + \mathrm{se}_{\beta_{1,2}}^2} \end{array}}

The prediction interval when using this regression is a function of the standard errors:

  .. math::

    f_{(x)} = \beta_{0,1} * x + \beta_{1,1} + t_{\nu} \left( \mathrm{se}_{\beta_{0}}^2 x^2 + \mathrm{se}_{\beta_{1}}^2 + 2 \mathrm{se}_{\beta_{0}} \mathrm{se}_{\beta_{1}} \rho_{01} x \right) ^ \frac{1}{2}

where the t-statistic has :math:`\nu = I - 2` degrees of freedom and :math:`\rho_{01}` is the slope-intercept correlation (associated with error source 1).

Within the MCM, the j\ :sup:`th` carbon mass injected during the CH\ :sub:`4`\ -loop is quantified by:

  1. Obtaining a random calibration area, :math:`C_j`;

  2. Obtaining a random T-variable from the standard T-distribution with :math:`\nu` degrees of freedom; and

  3. Computing the j\ :sup:`th` carbon mass: :math:`m_{C,j} = f_{(C_j)}`.

Finally, a :ref:`generalized T-distribution <AnchorToTDist>` is fit to :math:`m_{C,j}` via maximum likelihood estimation and is reported in the *OCECgo* GUI.

****************************
NDIR Correction: Convex Hull
****************************

The Sunset Laboratory Model 4 instrument measures evolved carbon as carbon dioxide using a non-dispersive infrared (NDIR) detector. The detector is known to drift over a relatively short time-frame, such that the baseline of the NDIR signal (the "true zero" of the detector) is not constant during a thermal-optical analysis. Consequently, the baseline NDIR signal must be estimated and the raw NDIR signal must be corrected to enable an accurate measure of evolved carbon.  Fortuitously, at specific instances during a thermal-optical analysis, it can be expected that carbon dioxide is not present in the instrument, including:

  * At the start of the thermal protocol, following purge of the instrument with helium.

  * Immediately prior the Ox-phase of the thermal protocol, where organic carbon has completely pyrolyzed.

  * Immediately following the thermal protocol, prior to the CH\ :sub:`4`\ -loop.

If it is known with confidence that carbon dioxide from evolved organic (OC) and elemental carbon (EC) is not present at these instances, then they can be used to derive the baseline of the NDIR detector. Indeed, the proprietary software provided with the instrument performs a linear fit to these data when correcting the NDIR signal for drift. The *OCECgo* software tool allows the user to estimate the NDIR baseline with the linear fit performed by the instrument. This is accomplished by selecting the "From results file" option in section 2(b) of the "Data Analysis Tool - Inputs" tab. Instrument-reported total and calibration areas are acquired from an appropriate results file and are used to back-calculate the NDIR correction and apply it to the raw signal. However, if unexpected carbon dioxide is present, this linear fit drift correction procedure will provide erroneous results - this has been observed by the author(s) and is discussed within the literature [3]_.

Alternatively, *OCECgo* allows the user to perform the NDIR correction with a novel method termed the "Convex Hull" technique. This approach leverages the fact that (disregarding noise in the NDIR detector) the quantity of NDIR-measured carbon dioxide is by definition non-negative.  That is, the NDIR signal will always represent the presence of zero or more carbon dioxide. With this in mind, the NDIR baseline is quantified in this technique by computing a (lower) convex hull that bounds the raw NDIR signal.  This is an improvement to the above technique in that the NDIR correction may therefore be non-linear (piecewise) and it does not make any prior assumptions that the carbon dioxide concentration measured by the NDIR should be zero at any specific moment in time. Specifics of the technique are presented in the **Algorithm** section below.

Algorithm
=========

Let :math:`{\left\{x_t : t\ \in\ {1...T}\right\}}` represent the NDIR time-series, reported at a frequency of 1 Hz for a total of :math:`T` seconds. For a time-series, a point :math:`x_t` is a vertex of the lower convex hull if there exists another point at :math:`t'` such that the line through :math:`x_t` and :math:`x_{t'}` is a lower bound to every point in the time series. Mathematically:

  .. math::

    x_t \in S \iff \exists\ t' : \frac{x_i - x_t}{i - t} \geq \frac{x_{t'} - x_t}{t' - t},\ \forall\ i \in {1...T}

where :math:`S` is the set of vertices of the lower convex hull.

To compute the NDIR baseline within the *OCECgo* algorithm, two additional steps are taken:

  1. A positive shift is applied to the convex hull vertices to account for the noise characteristic of the NDIR detector.

  2. Cubic interpolation of the convex hull vertices is performed to obtain the NDIR correction at all instances in time.

MATLAB Code
-----------

Shown below is example MATLAB code to compute the NDIR baseline of the time-series :code:`x` using the convex hull technique.

.. code-block:: matlab

  % Get length of time-series
  T = length(x);

  % Initialize vector to track indices of lower convex hull vertices.
  % The first and last point of the time-series are always vertices of the hull
  vertices = 1;

  % Compute indices of lower convex hull vertices
  index = 1;
  while index < T

    % Find slope from existing point to all of the following points
    slope_to_next_point = (x(index+1 : T) - x(index)) ./ (1 : T - index);

    % Determine the index of the point with minimum slope
    [~, index_of_minimum] = min(slope_to_next_point);

    % Update to next index
    index = index + index_of_minimum;

    % Update vertice tracking
    vertices = cat(1, vertices, index);

  end

  % Calculate NDIR baseline
  NDIR_baseline = x(vertices);

  % Add positive shift to account for instrument noise
  NDIR_baseline = NDIR_baseline + noise_characteristic;

  % Perform cubic interpolation to obtain time-series of NDIR baseline
  NDIR_baseline = interp1(vertices, NDIR_baseline, 1 : T, 'cubic');

********************************************
Split Point Uncertainty: Attenuation Decline
********************************************

*OCECgo* includes an optional, novel technique for the estimation of split point uncertainty - the *Attenuation Decline* technique. This method leverages the notion that there exists quantifiable uncertainty in instantaneous laser attenuation through the quartz filter such that uncertainty in split point estimation by the thermal-optical transmittance (TOT) method can be objectively quantified. The procedure is to first compute the nominal split point using the TOT method with the computed initial laser attenuation. The initial attenuation is then decreased by some fraction and a secondary split point is computed using the TOT method. By selecting the attenuation decrease based on the ability to quantify attenuation (i.e., the 2σ uncertainty in instantaneous attenuation), the difference in the computed split points represents the 2σ uncertainty in the split point – i.e., uncertainty in attenuation is propagated through the TOT method.

TOT Method
==========

The TOT method enables the estimation of split point by leveraging the assumption that the optical properties of pyrolyzed carbon (PC) and EC are approximately equal. If true, the split point is estimated as the instance in time when laser attenuation (which first increases due to pyrolization of OC) recovers to the value at the start of the analysis. Let :math:`I_{(t)}^o` and :math:`I_{(t)}^t` represent the incident laser intensity (optically upstream of the quartz filter) and transmitted (measured) laser intensity at time :math:`t`. Attenuation is:

  .. math::

    A_{(t)} = -\mathrm{ln}\left( \frac{I_{(t)}^t}{I_{(t)}^o} \right)

The premise of the TOT method is then to find the latest time :math:`t_s` such that :math:`A_{(t_s)} \approx A_{(0)}`. Simple algebraic manipulation yields an alternative form of this equation, which is useful for the estimation of split point uncertainty:

  .. math::

    t_s = t : \frac{I_{(0)}^t}{I_{(t)}^t} \frac{I_{(t)}^o}{I_{(0)}^o} \approx 1

Split Point Uncertainty
=======================

Within the *OCECgo* algorithm, the instantaneous incident intensity, :math:`I_{(t)}^o`, is modelled as a function of measured (actual) oven temperature, :math:`f_{(T_{a(t)})}`. The critical equation for the TOT method is therefore:

  .. math::

    \frac{I_{(0)}^t}{I_{(t)}^t} \frac{f_{(T_{a(t)})}}{f_{(T_{a(0)})}} \approx 1

where :math:`f_{(x)}` is a second- or first-order polynomial, as chosen by the user.

By inspection, uncertainty of the TOT method - i.e., uncertainty in the left-hand side of the equation, :math:`U_{TOT}` - is a function of three items that are quantified using laser power and oven temperature data from the CH\ :sub:`4`\ -loop of the thermal protocol:

  1. Noise in the photodiode measuring the laser power - affecting :math:`I_{(0)}^t` and :math:`I_{(t)}^t`.  Represented by the relative 2σ uncertainty of the photodiode, :math:`U_I`.

  2. Noise in the thermocouple measuring front oven temperature - affecting :math:`T_{a(0)}` and :math:`T_{a(t)}`.  Represented by the relative 2σ uncertainty of the thermocouple, :math:`U_T`.

  3. Uncertainty of the model of incident intensity as a function of oven temperature - affecting :math:`f_{(x)}`.  Represented by the relative 2σ prediction interval of the regression, :math:`U_f`.

Instrument noise (items 1 and 2) is inherently uncorrelated in time, but uncertainty in the model of incident intensity as a function of oven temperature (item 3) may in fact be correlated in time. Propagating these uncertainties with a first-order Taylor series expansion, uncertainty in the TOT method is:

  .. math::

    U_{TOT} = 2U_I^2 + 2U_T^2 + 2U_f^2 \left( 1 - \rho_{f(t_s)} \right)

where :math:`\rho_{f(t_s)} \in [-1,1]` is the correlation of the fitted model at :math:`T_{a(0)}` and :math:`T_{a(t)}`. While this correlation cannot be predicted, *OCECgo*  assumes :math:`\rho_f = -1` to yield a conservative estimate of :math:`U_{TOT}`:

  .. math::

    U_{TOT} = 2U_I^2 + 2U_T^2 + 4U_f^2

*OCECgo*-recommended Attenuation Decline
========================================

If the assumption that the optical properties of PC and EC were accurate, the above-derived :math:`U_{TOT}` would represent the attenuation decline necessary to quantify split point uncertainty when using the TOT method. However, this assumption should not be expected to be true. Consequently, when recommending a decline in attenuation, *OCECgo* expands :math:`U_{TOT}` by a factor of 2 to consider (at least in part) uncertainty due to the assumption of equal PC-EC optical properties.

************************************
Carbon Mass: Posterior Distributions
************************************

For each analysis, *OCECgo* reports the best-fitting posterior distribution for OC, EC, and total carbon (TC) mass. The distribution is selected from a set of 9 candidate distributions (shown below in alphabetical order) that are fit using Maximum Likelihood Estimation. The best-fitting distribution is selected using the Akaike Information Criterion [4]_.

Candidate distributions
=======================

Extreme Value
-------------

  .. math::

    f(x|\mu,\sigma) = \frac{1}{\sigma} \textrm{exp} \left( \frac{x-\mu}{\sigma} \right) \textrm{exp} \left( {-\textrm{exp} \left( \frac{x-\mu}{\sigma} \right)} \right)

Folded-Normal
-------------

  .. math::

    f(x|\mu,\sigma) = \frac{1}{\sigma\sqrt{2\pi}} \left[ \textrm{exp} \left( \frac{-(x-\mu)^2}{2\sigma^2} \right)  + \textrm{exp} \left( \frac{-(x+\mu)^2}{2\sigma^2} \right)\right]

  .. note::

    The folded-normal distribution is equivalent to the normal distribution with non-negative support - i.e., if :math:`\mu \gg \sigma`, the folded-normal and normal distributions are effectively equal. As such, if :math:`\mu \gt 3\sigma`, *OCECgo* will not consider the folded-normal distribution for the best fit.

Gamma
-----

  .. math::

    f(x|a,b) = \frac{1}{b^a \Gamma (a)} x^{a-1} \textrm{exp} \left( \frac{-x}{b} \right)

.. _AnchorToTDist:

Generalized T
-------------

  .. math::

    f(x|\mu,\sigma,\nu) = \frac{\Gamma \left( \frac{\nu+1}{2} \right)}{\sigma\sqrt{\nu\pi}\ \Gamma\left( \frac{\nu}{2} \right)} \left[ \frac{\nu + \left( \frac{x-\mu}{\sigma} \right) ^2}{\nu} \right] ^{-\frac{\nu+1}{2}}

  .. note::

    The generalized T distribution converges to the normal distribution at large degrees of freedom, :math:`\nu`. As such, if :math:`\nu \gt 60`, *OCECgo* will not consider the generalized T distribution for the best fit.

Logistic
--------

  .. math::

    f(x|\mu,\sigma) = \frac{\textrm{exp} \left( \frac{x-\mu}{\sigma} \right)}{\sigma \left[ {1 + \textrm{exp} \left( \frac{x-\mu}{\sigma} \right) } \right] ^2}

Log-logistic
------------

  .. math::

    f(x|\mu,\sigma) = \frac{\textrm{exp} \left( \frac{\mathrm{ln}\ x-\mu}{\sigma} \right)}{\sigma x \left[ {1 + \textrm{exp} \left( \frac{\mathrm{ln}\ x-\mu}{\sigma} \right) } \right] ^2}

Lognormal
---------

  .. math::

    f(x|\mu,\sigma) = \frac{1}{x\sigma\sqrt{2\pi}} \textrm{exp} \left( \frac{-(\mathrm{ln}\ x-\mu)^2}{2\sigma^2} \right)

Normal
------

  .. math::

    f(x|\mu,\sigma) = \frac{1}{\sigma\sqrt{2\pi}} \textrm{exp} \left( \frac{-(x-\mu)^2}{2\sigma^2} \right)

Rayleigh
--------

  .. math::

    f(x|b) = \frac{x}{b^2} \textrm{exp} \left( \frac{-x^2}{2b^2} \right)

**********
References
**********

.. [1] Conrad, B.M. & Johnson, M.R., Calibration Protocol and Software for Split Point Analysis and Uncertainty Quantification of Thermal-Optical Organic / Elemental Carbon Measurements, **J. Vis. Exp.** (2019), *in-press*.
.. [2] Darros-Barbosa, R., Balaban, M., Teixeira, A., Temperature and concentration dependence of density of model liquid foods.  **Int. J. Food Prop.**. 6(2), 195-214, doi: `10.1081/JFP-120017815 <https://doi.org/10.1081/JFP-120017815>`_ (2003).
.. [3] Zheng, G.J., Cheng Y., He K.B., Duan F.K., & Ma Y.L., A newly identified discrepancy of the sunset semi-continuous carbon analyzer. **Atmos. Meas. Tech.**. 7, 1969-1977, doi: `10.5194/amt-7-1969-2014 <https://doi.org/10.5194/amt-7-1969-2014>`_ (2014).
.. [4] Akaike, H., A new look at the statistical model identification. **IEEE Trans. on Autom. Cont.**. 19(6), 716-723, doi: `10.1109/TAC.1974.1100705 <http://doi.org/10.1109/TAC.1974.1100705>`_ (1974).
