<HTML><h3>Terms and Conditions for using Snow Algae Model:</h3>

<BIG><B><U>A user must agree to following terms and conditions before usage.</U></B></BIG>

<P ALIGN=JUSTIFY>Snow Algae Model is 1-D Numerical model for predicting snow algal growth using meteorological and snow physical conditions (Onuma et al., 2016, 2018, 2020, 2022). The latest version of Snow Algae Model has been incorporated into a land surface model MATSIRO6 established by Japanese modelling community in order to quantify spatio-temporal change in snow algal abundance globally (Onuma et al., 2022). Snow Algae Model is made freely available to the public and the scientific community in the belief that their wide dissemination will lead to greater understanding and new scientific insights. The availability of Snow Algae Model does not constitute publication of the model. We rely on the ethics and integrity of the user to assure that Yukihiko Onuma (YO hereafter) receives fair credit for our work. If Snow Algae Model are obtained for potential use in a publication or presentation, YO should be informed at the outset of the nature of this work. If Snow Algae Model are essential to the work, or if an important result or conclusion depends on the model, co-authorship may be appropriate. This should be discussed at an early stage in the work. Manuscripts using Snow Algae Model should be sent to YO for review before they are submitted for publication so that it can be insured that the quality and limitations of Snow Algae Model are accurately represented.</P>

<h3>The content published on GitHub:</h3>
<P ALIGN=JUSTIFY>
<UL><LI><B>source</B>: Programs to run Snow Algae Model in a stand-alone style (Fortran and text files). The equations for snow algal growth are described in SnowAlgae_Growth.f90. If you want to incorporate Snow Algae Model into your land surface or climate models, please see the Fortran file.</UL>
<UL><LI><B>input</B>: Input data for Snow Algae Model (CSV files). The meteorological and snow physical data every 1 hour are required to run Snow Algae Model.</UL>
<UL><LI><B>output</B>: Output data for Snow Algae Model (CSV and text files).</UL>
<UL><LI><B>fig</B>: Program for visualization of output results (Python file) and figures created by the Python scripts (PNG files).</UL>
<UL><LI><B>Makefile</B>: text file for compile Snow Algae Model</UL>
</P>

<h3>Information of variables used in input and output:</h3>
<P ALIGN=JUSTIFY>
<B><VAR>ymd</B> : YYYYMMDD
<br><B><VAR>time</B></VAR> : HHMMSS
<br><B><VAR>swe</B> : Snow water equivalent (kg/m2)
<br><B><VAR>sst</B> : Snow surface temperature (K)
<br><B><VAR>ssrd</B> : Downward Shortwave radiation (W/m2)
<br><B><VAR>gsnwl</B> : Snowfall rate (kg/m2/s)
<br><B><VAR>gp-</B> : Growth period of snow algae (hour)
<br><B><VAR>cellA-</B> : Algal cell concentration per area (cells/m2)
<br><B><VAR>bioA-</B> : Algal bio-volume per area (uL/m2)
<br><B><VAR>cellV-</B> : Algal cell concentration per volume (cells/L)
<br><B><VAR>bioV-</B> : Algal bio-volume per volume (uL/L)
<br><B><VAR>ocV-</B> : Organic carbon of snow algae per volume (mg/L)
<br><B><VAR>-MAL</B> : Variable simulated using a Malthusian model described in Onuma et al. (2016). In the MAL model, snow algal abundance increases with snow melting on the surface snow.
<br><B><VAR>-XM</B> : Variable simulated using a Snow Algae Model described in Onuma et al. (2018, 2020). In the XM model, snow algal abundance increases with snow melting on the surface snow until reaching to the carrying capacity.
<br><B><VAR>-XMD</B> : Variable simulated using a Snow Algae Model described in Onuma et al. (2022). In the XMD model, snow algal abundance increases with snow melting on the surface snow under day-light condition. The abundance can increases until reaching to  the carrying capacity.
<br><B><VAR>-XMDF</B> : Variable simulated using a Snow Algae Model described in Onuma et al. (2022). In the XMD model, snow algal abundance increases with snow melting on the surface snow under day-light condition and decreases with snowfall amount. The abundance can increases until reaching to the carrying capacity.
</P>

<h3>How to run Snow Algae Model:</h3>
$cd SnowAlgaeModel (model directory)
<br>$make all
<br>$cd work
<br>$make
<br>$vi fpath.nml (modify file path for input and output)
<br>$./run_snowalgae.sh

<h3>References:</h3>
<P ALIGN=JUSTIFY>
Onuma, Y., Takeuchi, N., & Takeuchi, Y. (2016), Temporal changes in snow algal abundance on surface snow in Tohkamachi, Japan. Bull. Glaciol. Res., 34, 21-31. doi:10.5331/bgr.16A02
<br>Onuma, Y., Takeuchi, N., Tanaka, S., Nagatsuka, N., Niwano, M., & Aoki, T. (2018), Observations and modelling of algal growth on a snowpack in north-western Greenland. Cryosphere, 12, 2147–2158. doi:10.5194/tc-12-2147-2018
<br>Onuma, Y., Takeuchi, N., Tanaka, S., Nagatsuka, N., Niwano, M., & Aoki, T. (2020), Physically based model of the contribution of red snow algal cells to temporal changes in albedo in northwest Greenland. Cryosphere, 14, 2087-2101. doi:10. 5194/tc-14-2087-2020
<br>Onuma, Y., Yoshimura, K., & Takeuchi, N. (2022). Global simulation of snow algal blooming by coupling a land surface and newly developed snow algae models. Journal of Geophysical Research: Biogeosciences, 127, e2021JG006339
</P>
<br><P ALIGN=RIGHT>(Last Revision: February 3, 2022)</P>
</HTML>
