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
dataset = load_dataset(script_dir.joinpath("simData05.ascii"))
# plot_data_overview(dataset)

# %%
def run_kinetic_model(show_plot=False, block_plot=False):

    print(f"\n{'#'*10} Kinetic Model {'#'*10}\n")
    kin_model = load_model(script_dir.joinpath("models/kin_model.yml"))
    kin_parameters = load_parameters(script_dir.joinpath("models/kin_params.yml"))
    kin_model.validate(parameters=kin_parameters)

    kin_scheme = Scheme(
        kin_model,
        kin_parameters,
        data={"dataset": dataset},
    )
    kin_result = optimize(kin_scheme)

    print(f"\n{'#'*3} Kinetic Model - Optimization Result {'#'*3}\n")
    print(kin_result)
    print(f"\n{'#'*3} Kinetic Model - Optimized Parameters {'#'*3}\n")
    print(kin_result.optimized_parameters)
    if show_plot:
        plot_overview(kin_result.data["dataset"], linlog=False)
        plt.show(block=block_plot)

# %%
def run_spectral_model(show_plot=False, block_plot=False):
    print(f"\n{'#'*10} Spectral Model {'#'*10}\n")
    spectral_model = load_model(script_dir.joinpath("models/spectral_model.yml"))
    spectral_parameters = load_parameters(
        script_dir.joinpath("models/spectral_params.yml")
    )
    spectral_model.validate(parameters=spectral_parameters)
    # print(spectral_model)

    # %%
    spectral_scheme = Scheme(
        spectral_model,
        spectral_parameters,
        data={"dataset": dataset},
    )
    spectral_result = optimize(spectral_scheme)
    print(f"\n{'#'*3} Spectral Model - Optimization Result {'#'*3}\n")
    print(spectral_result)

    # %%
    print(f"\n{'#'*3} Spectral Model - Optimized Parameters {'#'*3}\n")
    print(spectral_result.optimized_parameters)
    if show_plot:
        plot_overview(spectral_result.data["dataset"], linlog=False)
        plt.show(block=block_plot)


def run_spectrotemporal_model(show_plot=False, block_plot=False):
    # %% Full Model (a.k.a. spectrotemporal model)
    print(f"\n{'#'*10} Spectrotemporal ('Full') Model {'#'*10}\n")
    spectemp_model = load_model(script_dir.joinpath("models/full_model.yml"))
    spectemp_parameters = load_parameters(script_dir.joinpath("models/full_params.yml"))
    spectemp_model.validate(parameters=spectemp_parameters)

    # %%
    spectemp_scheme = Scheme(
        spectemp_model,
        spectemp_parameters,
        data={"dataset": dataset},
        # group=False
    )

    spectemp_result = optimize(spectemp_scheme)
    print(spectemp_result)
    print(f"\n{'#'*3} Spectrotemporal Model - Optimization Result {'#'*3}\n")

    # %%
    print(f"\n{'#'*3} Spectrotemporal Model - Optimized Parameters {'#'*3}\n")
    print(spectemp_result.optimized_parameters)
    plot_overview(spectemp_result.data["dataset"], linlog=True, linthresh=80)
    plt.show(block=block_plot)


# %% Validate results by manual inspection
# TODO: automate this

if __name__=="__main__":
    run_kinetic_model(show_plot=True, block_plot=True)
    run_spectral_model(show_plot=True, block_plot=True)
    run_spectrotemporal_model(show_plot=True, block_plot=True)