# To add a new cell, type '# %%'
# To add a new markdown cell, type '# %% [markdown]'
# %%
from pathlib import Path

import matplotlib.pyplot as plt
from pyglotaran_extras.plotting.data import plot_data_overview
from pyglotaran_extras.plotting.plot_overview import plot_overview
from pyglotaran_extras.plotting.style import PlotStyle
from glotaran.analysis.optimize import optimize
from glotaran.io import load_dataset
from glotaran.io import load_model
from glotaran.io import load_parameters
from glotaran.project.scheme import Scheme

script_dir = Path(__file__).resolve().parent
print(f"Script folder: {script_dir}")
script_dir.cwd()

plot_style = PlotStyle()
plt.rc("axes", prop_cycle=plot_style.cycler)
plt.rcParams["figure.figsize"] = (21, 14)

# %%
dataset = load_dataset(script_dir.joinpath("simData01.ascii"))
# plot_data_overview(dataset)

# %%
kin_model = load_model(script_dir.joinpath("models/kin_model.yml"))
kin_parameters = load_parameters(script_dir.joinpath("models/kin_params.yml"))
kin_model.validate(parameters=kin_parameters)

# %%
kin_scheme = Scheme(
    kin_model,
    kin_parameters,
    data={"dataset": dataset},
)
# kin_result = optimize(kin_scheme)
# plot_overview(kin_result.data["dataset"], linlog=False);

# %%
spectral_model = load_model(script_dir.joinpath("models/spectral_model.yml"))
spectral_parameters = load_parameters(
    script_dir.joinpath("models/spectral_params.yml")
)
spectral_model.validate(parameters=spectral_parameters)
print(spectral_model)

# %%
spectral_scheme = Scheme(
    spectral_model,
    spectral_parameters,
    data={"dataset": dataset},
)
spectral_result = optimize(spectral_scheme)
print(spectral_result)

# %%
plot_overview(spectral_result.data["dataset"], linlog=False)
print(spectral_result.optimized_parameters)
plt.show(block=True)

# %% Full Model (a.k.a. spectrotemporal model)
# TODO: spectrotemporal model pending the full model implementation in pyglotaran


# %% Validate results by manual inspection
# TODO: automate this