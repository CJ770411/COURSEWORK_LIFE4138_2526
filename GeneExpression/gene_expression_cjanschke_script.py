#!/usr/bin/env python3

### Title: Gene expression challenge script
### Author: Chris Janschke
### Date: 11.12.2025
### Description: Code for the gene expression challenge in the L4138 coursework. Dataset_09 currently inputted as dataset.


import pandas as pd
import plotly.express as px
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns


def read_file_tsv(path):
    """
    Read in a tsv file and return a pandas dataframe.

    Parameters:
    path (string): Path to the tsv file

    Returns:
    pandas dataframe: tsv file as a pandas dataframe
    """
    try:
        tsv_file = pd.read_csv(path, sep='\t') # read in tsv file from param 'path' as pandas dataframe
        print("File successfully read in.\n")
        return tsv_file # return tsv file as pandas dataframe
    except FileNotFoundError:
        print("File not found. Please enter a valid path.")


def sig_gene_count(direction, dataset):
    """
    Calculate number of significantly DE genes.

    Parameters:
    direction (string): Direction of significance 'up', 'down' or 'both'
    dataset (pandas dataframe): Dataframe containing gene expression data

    Returns:
    string: Number of significantly DE
    """

    up_threshold = log2FC_threshold
    down_threshold = -log2FC_threshold
    if direction == 'up':
        print(f"The number of DE genes calculated using the following thresholds:\nLog2FC (UP): >={up_threshold}\nPadj: <{padj_threshold}\n") # display thresholds for calculation
        up_genes = dataset[dataset['log2FoldChange'] >= up_threshold] # filters by upregulated genes
        up_genes_count = len(up_genes) # counts upregulated genes
        print(f"Upregulated genes = {up_genes_count}\n")

    elif direction == 'down':
        print(f"The number of DE genes calculated using the following thresholds:\nLog2FC (DOWN): <={down_threshold}\nPadj: <{padj_threshold}\n") # display thresholds for calculation
        down_genes = dataset[dataset['log2FoldChange'] <= down_threshold] # filters by downregulated genes
        down_genes_count = len(down_genes) # counts downregulated genes
        print(f"Downregulated genes = {down_genes_count}\n")

    elif direction == 'both':
        print(f"The total number of significantly DE genes calculated using the following thresholds:\nLog2FC (UP): >={log2FC_threshold}\nLog2FC (DOWN): <={down_threshold}\nPadj: <{padj_threshold}\n") # display thresholds for calculation
        all_genes = len(dataset['log2FoldChange']) # counts all upregulated and downregulated genes
        print(f"Total DE genes = {all_genes}\n")

    else:
        print("Invalid direction input. Please enter 'up' for upregulated genes, 'down' for downregulated genes or 'both' for both upregulated and downregulated genes. Then enter the dataset.\n")


# function to determine direction and significance of gene expression
def gene_significance(row):
    """
    Identify significant DE genes and their respective direction.

    Parameters:
    row (string): The row in a pandas dataframe containing a gene.

    Returns:
    string: 'Up' (significantly upregulated), 'Down' (significantly downregulated or 'Non_significant'
    """
    if row['log2FoldChange'] >= log2FC_threshold and row['padj'] < padj_threshold:
        return 'Up'
    elif row['log2FoldChange'] <= log2FC_threshold and row['padj'] < padj_threshold:
        return 'Down'
    else:
        return 'Non significant'

# read in first .tsv file (deseq2_D = A_vs_D)
deseq2_D = read_file_tsv("~/GIT/COURSEWORK_LIFE4138_2526/GeneExpression/Datasets/set_9/A_vs_D.deseq2.results.tsv") # input path to the first .tsv file within the quote marks

# read in second .tsv file (deseq2_F = A_vs_F)
deseq2_F = read_file_tsv("~/GIT/COURSEWORK_LIFE4138_2526/GeneExpression/Datasets/set_9/A_vs_F.deseq2.results.tsv") # input path to the second .tsv file within the quote marks


##Summary Statistics
##1 Number of significantly upregulated and downregulated genes

# create thresholds for significance
log2FC_threshold = 1
padj_threshold = 0.01

# create dataframe including only significant genes
sig_deseq2_D = (deseq2_D.query(f'(abs(log2FoldChange) >= {log2FC_threshold} and padj < {padj_threshold})'))
sig_deseq2_F = (deseq2_F.query(f'(abs(log2FoldChange) >= {log2FC_threshold} and padj < {padj_threshold})'))


try:
    # print significantly upregulated and downregulated genes in Condition A vs Condition D
    print('The number of significantly upregulated and downregulated genes in Condition A vs Condition D\n')
    sig_gene_count('up', sig_deseq2_D) # upregulated
    sig_gene_count('down', sig_deseq2_D) # downregulated
    sig_gene_count('both', sig_deseq2_D) # upregulated and downregulated

    # print significantly upregulated and downregulated genes in Condition A vs Condition F
    print('The number of significantly upregulated and downregulated genes in Condition A vs Condition D\n')
    sig_gene_count('up', sig_deseq2_F) # upregulated
    sig_gene_count('down', sig_deseq2_F) # downregulated
    sig_gene_count('both', sig_deseq2_F) # upregulated and downregulated
except TypeError:
    print("Invalid input. Please enter direction in quotation marks and dataset without quotation marks.\n")
except NameError:
    print("Invalid input. Please enter a valid dataset and ensure direction is entered in quotation marks.\n")

##2 Summary of p-values and log fold changes across all genes for each comparison

## create table of summary statistics for each comparison
summary_table_D = deseq2_D[['log2FoldChange', 'padj']].describe()
summary_table_F = deseq2_F[['log2FoldChange', 'padj']].describe()
print(f'This table provides summary statistics for log2FoldChange and adjusted p-values for all genes in Condition A vs Condition D:\n\n {summary_table_D}\n')
print(f'This table provides summary statistics for log2FoldChange and adjusted p-values for all genes in Condition A vs Condition F:\n\n {summary_table_F}\n')

## calculate number of genes with adjusted p value below significance threshold

# Condition A vs Condition D
statistically_sig_genes_D = sum(deseq2_D['padj'] < padj_threshold) # below adjusted p-value threshold
statistically_insig_genes_D = sum(deseq2_D['padj'] >= padj_threshold) # above adjusted p-value threshold
print(f'The number of statistically significant genes in Condition A vs Condition D was calculated using an adjusted p-value threshold of <{padj_threshold}.\n\nStatistically significant genes = {statistically_sig_genes_D}\nStatistically insignificant genes = {statistically_insig_genes_D}\n')

# Condition A vs Condition F
statistically_sig_genes_F = sum(deseq2_F['padj'] < padj_threshold) # below adjusted p-value threshold
statistically_insig_genes_F = sum(deseq2_F['padj'] >= padj_threshold) # above adjusted p-value threshold
print(f'The number of statistically significant genes in Condition A vs Condition F was calculated using an adjusted p-value threshold of <{padj_threshold}.\n\nStatistically significant genes = {statistically_sig_genes_F}\nStatistically insignificant genes = {statistically_insig_genes_F}\n')

## create a boxplot of p-value distribution in both datasets

# create empty dataframe
pval_boxplot_data = pd.DataFrame()

# populate dataframe with p-values
pval_boxplot_data['Condition D'] = list((deseq2_D['pvalue']))
pval_boxplot_data['Condition F'] = list((deseq2_F['pvalue']))

# plot p-values
pval_boxplot = px.box(pval_boxplot_data)
pval_boxplot.update_layout(title=dict(text='Comparison of p-value distribution between Condition D and Condition F', font=dict(size=18)), xaxis_title='', yaxis_title='p-value', template='presentation')
pval_boxplot.show()

## create a boxplot of adjusted p-value distribution in both datasets

# create empty dataframe
padj_boxplot_data = pd.DataFrame()

# populate dataframe with adjusted p-values
padj_boxplot_data['Condition D'] = list((deseq2_D['padj']))
padj_boxplot_data['Condition F'] = list((deseq2_F['padj']))

# plot adjusted p-values
padj_boxplot = px.box(padj_boxplot_data)
padj_boxplot.update_layout(title=dict(text='Comparison of adjusted p-value distribution between Condition D and Condition F', font=dict(size=18)), xaxis_title='', yaxis_title='padj', template='presentation')
padj_boxplot.show()

## create a boxplot of log2 fold change distribution in both datasets

# create empty dataframe
log2FC_boxplot_data = pd.DataFrame()

# populate dataframe with log2 fold change values
log2FC_boxplot_data['Condition D'] = list((deseq2_D['log2FoldChange']))
log2FC_boxplot_data['Condition F'] = list((deseq2_F['log2FoldChange']))

# plot boxplot
log2FC_boxplot = px.box(log2FC_boxplot_data)
log2FC_boxplot.update_layout(title=dict(text='Comparison of log2FoldChange distribution between Condition D and Condition F', font=dict(size=18)), xaxis_title='', yaxis_title='log2FC', template='presentation')
log2FC_boxplot.show()

## Plots
## 1 (Volcano plot)

# create volcano plot for Condition A vs Condition D

deseq2_D['sig'] = deseq2_D.apply(gene_significance, axis=1) # create column for with DE gene significance and direction

fig = px.scatter(x=(deseq2_D['log2FoldChange']), y=(-np.log10(deseq2_D['padj'])),
                 color=deseq2_D['sig'], color_discrete_sequence=['darkturquoise', 'darksalmon', 'gray'],
                 hover_name= deseq2_D['gene_id'], hover_data=[deseq2_D['log2FoldChange']],
                 title = 'Volcano plot of differential gene expression analysis for Conditions A vs Condition D',
                 labels = {
                     'x': 'Log2FC',
                     'y': '-log10padj',
                     'color': 'Gene Expression',
                 }, template = 'plotly_white')
fig.update_layout(
    hoverlabel=dict(
        bgcolor="white",
        font_size=10,
        font_family="Aptos"
    )
)
fig.add_vline(x=1, line_width=1, line_dash="dash", line_color="grey") # add threshold line for upregulated genes
fig.add_vline(x=-1, line_width=1, line_dash="dash", line_color="grey") # add threshold line for downregulated genes
fig.add_hline(y=2, line_width=1, line_dash="dash", line_color="grey") # add threshold line for adjusted p-value
fig.show()

# create volcano plot for Condition A vs Condition F

deseq2_F['sig'] = deseq2_F.apply(gene_significance, axis=1) # create column for with DE gene significance and direction

fig = px.scatter(x=(deseq2_F['log2FoldChange']), y=(-np.log10(deseq2_F['padj'])),
                 color=deseq2_F['sig'], color_discrete_sequence=['darkturquoise', 'darksalmon', 'gray'],
                 hover_name= deseq2_F['gene_id'], hover_data=[deseq2_F['log2FoldChange']],
                 title = 'Volcano plot of differential gene expression analysis for Condition A vs Condition F',
                 labels = {
                     'x': 'Log2FC',
                     'y': '-log10padj',
                     'color': 'Gene Expression',
                 }, template = 'plotly_white')
fig.update_layout(
    hoverlabel=dict(
        bgcolor="white",
        font_size=10,
        font_family="Aptos"
    )
)
fig.add_vline(x=1, line_width=1, line_dash="dash", line_color="grey") # add threshold line for upregulated genes
fig.add_vline(x=-1, line_width=1, line_dash="dash", line_color="grey") # add threshold line for downregulated genes
fig.add_hline(y=2, line_width=1, line_dash="dash", line_color="grey") # add threshold line for adjusted p-value
fig.show()

##2 (MA plot)

# create new df with log mean expression calculated from base mean
deseq2_D_logmean = deseq2_D.assign(logMeanExpression = np.log2(deseq2_D['baseMean'] + 1)) # pseudocount of 1 to ensure genes with base mean of 0 don't skew the graph data
deseq2_F_logmean = deseq2_F.assign(logMeanExpression = np.log2(deseq2_F['baseMean'] + 1)) # pseudocount of 1 to ensure genes with base mean of 0 don't skew the graph data

# create MA plot

#create MA plot for Condition A vs Condition D
sns.scatterplot(data=deseq2_D_logmean, x ='logMeanExpression', y ='log2FoldChange', hue='sig', hue_order=['Up', 'Down', 'Non significant'], palette='viridis', alpha=0.8, s = 10)
plt.title('MA plot showing differential gene expression for Condition A vs Condition D', fontsize=10)
plt.xlabel('Log2 Mean Expression', fontsize=10)
plt.ylabel('Log2FC', fontsize=10)
plt.legend(title = 'Gene Expression', loc='upper right', markerscale=3, fontsize=8)
plt.axhline(y = 0, color = 'black', linestyle = '--', alpha = 0.5) # create reference line at 0 for log2 fold change
plt.show()

# create MA plot for Condition A vs Condition F
sns.scatterplot(data=deseq2_F_logmean, x ='logMeanExpression', y ='log2FoldChange', hue='sig', hue_order=['Up', 'Down', 'Non significant'], palette='viridis', alpha=0.8, s = 10)
plt.title('MA plot showing differential gene expression for Condition A vs Condition F', fontsize=10)
plt.xlabel('Log2 Mean Expression', fontsize=10)
plt.ylabel('Log2FC', fontsize=10)
plt.legend(title = 'Gene Expression', loc='upper right', markerscale=3, fontsize=8)
plt.axhline(y = 0, color = 'black', linestyle = '--', alpha = 0.5) # create reference line at 0 for log2 fold change
plt.show()

##3 (Histogram of P-values)
# create histogram for Condition A vs Condition D
fig = px.histogram(deseq2_D, x ='pvalue', opacity = 0.8, nbins = 50, marginal ='box', # set no. bins to 50, add box plot to graph
                   title = 'Histogram of P-values for Condition A vs Condition D',
                   subtitle = 'Distribution illustrated by boxplot')

fig.update_xaxes(title = 'P-value', title_font = dict(size = 20))
fig.update_yaxes(title = 'Frequency', title_font = dict(size = 20))
fig.show()

# create histogram for Condition A vs Condition F
fig = px.histogram(deseq2_F, x ='pvalue', opacity = 0.8, nbins = 50, marginal ='box', # set no. bins to 50, add box plot to graph
                   title = 'Histogram of P-values for Condition A vs Condition F',
                   subtitle = 'Distribution illustrated by boxplot')

fig.update_xaxes(title = 'P-value', title_font = dict(size = 20))
fig.update_yaxes(title = 'Frequency', title_font = dict(size = 20))
fig.show()

##4 (Heatmap of top DE genes)
# create new dataframe with gene names as index
heatmap_data = pd.DataFrame(index=deseq2_D['gene_id'])

# add new column for Condition D and Condition F containing log2FoldChange counts
heatmap_data['Condition D'] = list((deseq2_D['log2FoldChange']))
heatmap_data['Condition F'] = list((deseq2_F['log2FoldChange']))

# converts any instances of 'NA' or missing data to 'NaN'
heatmap_data.replace(['NA', ''], np.nan, inplace=True)

# remove any NA values from data
heatmap_data.dropna(axis=0, how='any', inplace=True)

# select how many top DE genes to view
significant_gene_count = 25

# create heatmap for top DE genes in Condition D

# arrange dataset into descending order based on absolute values in Condition D
heatmap_data.sort_values(by=['Condition D'], key=abs, ascending=False, inplace=True)

# create new dataframe containing the top genes in Condition D
top_DE_genes_D = (heatmap_data.iloc[:significant_gene_count])

# plot heatmap for Condition D
plt.figure(figsize = (8,7))
heatmap_deseq2_D = sns.heatmap(top_DE_genes_D, annot=True, cmap="viridis", fmt='.2f')
heatmap_deseq2_D.set_title(f'Heatmap showing top {significant_gene_count} DE genes based on Condition D', fontweight='bold', pad=20)  # create title based on amount of top DE genes selected
plt.show()


# create heatmap for top DE genes in Condition F

# arrange dataset into descending order based on absolute values in Condition F
heatmap_data.sort_values(by=['Condition F'], key=abs, ascending=False, inplace=True)

# create new dataframe containing the top genes
top_DE_genes_F = (heatmap_data.iloc[:significant_gene_count])

# plot heatmap for Condition F
plt.figure(figsize = (8,7))
heatmap_deseq2_F = sns.heatmap(top_DE_genes_F, annot = True, cmap = "viridis", fmt = '.2f')
heatmap_deseq2_F.set_title(f'Heatmap showing top {significant_gene_count} DE genes based on Condition F', fontweight='bold', pad=20)  # create title based on amount of top DE genes selected
plt.show()


## Significant Gene Lists

# create individual table containing upregulated genes for each condition
deseq2_D_upregulated_table = (deseq2_D[deseq2_D.sig == 'Up'][['gene_id', 'log2FoldChange','pvalue', 'padj']]).sort_values(by='log2FoldChange', ascending=False)
deseq2_F_upregulated_table = (deseq2_F[deseq2_F.sig == 'Up'][['gene_id', 'log2FoldChange', 'pvalue', 'padj']]).sort_values(by='log2FoldChange', ascending=False)

# set index to gene names
deseq2_D_upregulated_table.set_index('gene_id', inplace=True)
deseq2_F_upregulated_table.set_index('gene_id', inplace=True)

#display total upregulated genes
print(f'This table contains all upregulated genes from Condition A vs Condition D based on the following thresholds:\nLog2FC: >={log2FC_threshold}\nPadj: <{padj_threshold}\n\nThe total number of upregulated genes = {len(deseq2_D_upregulated_table)}\n')
print(deseq2_D_upregulated_table)
print(f'This table contains all upregulated genes from Condition A vs Condition F based on the following thresholds:\nLog2FC: >={log2FC_threshold}\nPadj: <{padj_threshold}\n\nThe total number of upregulated genes = {len(deseq2_F_upregulated_table)}\n')
print(deseq2_F_upregulated_table)

# create individual table containing downregulated genes for each condition
deseq2_D_downregulated_table = (deseq2_D[deseq2_D.sig == 'Down'][['gene_id', 'log2FoldChange','pvalue', 'padj']]).sort_values(by='log2FoldChange', ascending=True)
deseq2_F_downregulated_table = (deseq2_F[deseq2_F.sig == 'Down'][['gene_id', 'log2FoldChange', 'pvalue', 'padj']]).sort_values(by='log2FoldChange', ascending=True)

# set index to gene names
deseq2_D_downregulated_table.set_index('gene_id', inplace=True)
deseq2_F_downregulated_table.set_index('gene_id', inplace=True)

#display total downregulated genes
print(f'This table contains all downregulated genes from Condition A vs Condition D based on the following thresholds:\nLog2FC: <=-{log2FC_threshold}\nPadj: <{padj_threshold}\n\nThe total number of downregulated genes = {len(deseq2_D_downregulated_table)}\n')
print(deseq2_D_downregulated_table)
print(f'This table contains all downregulated genes from Condition A vs Condition F based on the following thresholds:\nLog2FC: <=-{log2FC_threshold}\nPadj: <{padj_threshold}\n\nThe total number of downregulated genes = {len(deseq2_F_downregulated_table)}\n')
print(deseq2_F_downregulated_table)

# add new column with condition identifier to each dataset
deseq2_D.insert(len(deseq2_D.columns), 'Condition', 'Condition D')
deseq2_F.insert(len(deseq2_F.columns), 'Condition', 'Condition F')

# create combined table containing upregulated and downregulated genes for both conditions
significant_gene_table = (pd.concat([deseq2_D, deseq2_F]))[pd.concat([deseq2_D, deseq2_F])['sig'].isin(['Up', 'Down'])][['gene_id', 'log2FoldChange','pvalue', 'padj', 'Condition']].sort_values(by='log2FoldChange', ascending=False)

# set index to gene names
significant_gene_table.set_index('gene_id', inplace=True)

# display total upregulated and downregulated genes from both datasets
print(f'This table contains all upregulated and downregulated genes from Condition D and Condition F based on the following thresholds:\nLog2FC (UP): >=-{log2FC_threshold}\nLog2FC (Down): <=-{log2FC_threshold}\nPadj: <{padj_threshold}\n\nThe total number of upregulated and downregulated genes = {len(significant_gene_table)}\n')
print(significant_gene_table)


## Additional analyses

# Using a clustermap to investigate gene clustering
# dataframes top_DE_genes_D and top_DE_genes_F originally used for heatmap have been used again for clustermap

# select how many top DE genes to view for the clustermap plot
significant_gene_count_cm = 25

# create clustermap plot for top DE genes in Condition D

# include log2FoldChange values if viewing <= 20 genes
if significant_gene_count_cm <= 25:
    clustermap_plot_D = sns.clustermap(top_DE_genes_D, cmap='viridis', figsize=(7, 7), annot = True, fmt ='.2f')  # set colour scale and figure size
# exclude log2FoldChanges if viewing > 20 genes
else:
    clustermap_plot_D = sns.clustermap(top_DE_genes_D, cmap='viridis', figsize=(7, 7))  # set colour scale and figure size

plt.xlabel('log2FC')  # add label to colour scale
clustermap_plot_D.ax_heatmap.set_yticklabels(clustermap_plot_D.ax_heatmap.get_yticklabels(), fontsize=7)  # set gene name size
clustermap_plot_D.ax_heatmap.set_ylabel('')  # remove default dataframe column name from y-axis
clustermap_plot_D.fig.suptitle(
    f'Clustermap showing clustered relationship of top {significant_gene_count_cm} DE genes based on Condition D', fontsize = 11)  # create title based on amount of top DE genes selected
clustermap_plot_D.fig.subplots_adjust(top=0.94)  # move title up to avoid overlaying with dendrogram
plt.show()  # display clustermap


# create clustermap plot for top DE genes in Condition F

# include log2FoldChange values if viewing <= 20 genes
if significant_gene_count_cm <= 25:
    clustermap_plot_F = sns.clustermap(top_DE_genes_F, cmap='viridis', figsize=(7, 7), annot = True, fmt ='.2f')  # set colour scale and figure size
# exclude log2FoldChanges if viewing > 20 genes
else:
    clustermap_plot_F = sns.clustermap(top_DE_genes_F, cmap='viridis', figsize=(7, 7))  # set colour scale and figure size

plt.xlabel('log2FC')  # add label to colour scale
clustermap_plot_F.ax_heatmap.set_yticklabels(clustermap_plot_F.ax_heatmap.get_yticklabels(), fontsize=7)  # set gene name size
clustermap_plot_F.ax_heatmap.set_ylabel('')  # remove default dataframe column name from y-axis
clustermap_plot_F.fig.suptitle(
    f'Clustermap showing clustered relationship of top {significant_gene_count_cm} DE genes based on Condition F', fontsize = 11)  # create title based on amount of top DE genes selected
clustermap_plot_F.fig.subplots_adjust(top=0.94)  # move title up to avoid overlaying with dendrogram
plt.show()  # display clustermap
