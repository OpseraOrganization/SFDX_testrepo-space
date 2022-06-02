import { LightningElement, api } from 'lwc';
import { Chart, registerables } from 'c/chart';
import { clone, map, abbreviate } from 'c/utils';
//
const TYPES = {
    'Line' : 'line', 
    'Column' : 'column',
    'Bar' : 'bar',
    'Funnel' : 'funnel',
    'Donut' : 'doughnut',
    'Scatter' : 'scatter',
    'FlexTable' : 'table',
    'Metric' : 'metric',
    'Gauge' : 'gauge'
}
const COLORS = {
    light : ['#3296ED', '#77B9F2', '#9D53F2', '#C398F5', '#26ABA4', '#4ED4CD'],
    dark : ['#0E70C7', '#3296ED', '#7719E3', '#9D53F2', '#067D77', '#26ABA4'],
}
//
export default class DashboardView extends LightningElement {
    @api
    get component() { return this._component; }
    set component(value) {
        const component = clone(value || {});
        const { type, datasets, labels } = this.processData(component);
        this.type = type;
        switch(type) {
            default: this.buildChart(component, datasets, labels); break;
            case 'metric':
                this._component = {
                    value : abbreviate(datasets?.[0]?.value) || '',
                    style : `--color: #${datasets?.[0]?.color || (component.chartTheme === 'dark' ? 'fffff' : '696969')};`,
                }
                break;
            case 'gauge':
                const max = labels?.[labels?.length - 1]?.max || 100, data = datasets?.[0];
                this._component = {
                    value : abbreviate(data?.value) || '',
                    style : `--color: #${data?.color || (component.chartTheme === 'dark' ? 'fffff' : '696969')};--rotate: ${(((data?.value || 0) * 180) / max)}deg;`,
                    max : abbreviate(max),
                    scales : map(labels, (c) => ({
                        value : abbreviate(c.min), style : `--color: #${c.color}; --rotate: ${((c.min * 180) / max)}deg;`
                    }))
                };
                break;
            case 'table':
                this._component = {
                    columns : labels, data : datasets,
                    style : `--color: ${component.chartTheme === 'dark' ? 'white' : 'currentColor'}; --border: ${component.chartTheme === 'dark' ? 'rgba(255, 255, 255, 0.2)' : 'rgba(0, 0, 0, 0.1)'};`
                }
                break;
        }
    };

    get isMetric() { return this.type === 'metric'; }
    get isGauge() { return this.type === 'gauge'; }
    get isTable() { return this.type === 'table'; }
    get isChart() { return !['metric', 'gauge', 'table'].includes(this.type); }

    processData(component) {
        const type = TYPES[component.properties.visualizationType];
        const { groupingsDown, factMap } = component?.data?.reportResult || {};
        const theme = component.chartTheme;
        let datasets, labels;
        switch(type) {
            case 'metric':
                var breaks = component?.properties?.visualizationProperties?.breakPoints?.[0]?.breaks;
                var total = component?.data?.reportResult?.factMap?.['T!T']?.aggregates?.[0]?.value || 0;
                for(let i = 0, len = breaks?.length || 0; i < len; i++) {
                    if((breaks[i].lowerBound == null || total > breaks[i].lowerBound)
                    && (breaks[i].upperBound == null || total < breaks[i].upperBound)) {
                        datasets = [{ value : total, color : breaks[i].color }];
                        break;
                    }
                }
                break;
            case 'gauge':
                var breaks = component?.properties?.visualizationProperties?.breakPoints?.[0]?.breaks;
                var total = component?.data?.reportResult?.factMap?.['T!T']?.aggregates?.[0]?.value || 0;
                labels = map(breaks, (c) => ({min : c.lowerBound,  max : c.upperBound, color : c.color}));
                for(let i = 0, len = labels?.length || 0; i < len; i++) {
                    if((breaks[i].lowerBound == null || total > breaks[i].lowerBound)
                    && (breaks[i].upperBound == null || total < breaks[i].upperBound)) {
                        datasets = [{ value : total, color : breaks[i].color }];
                        break;
                    }
                }
                break;
            case 'table':
                var aggregateColumnInfo = component?.data?.reportResult?.reportExtendedMetadata?.aggregateColumnInfo;
                var groupingColumnInfo = component?.data?.reportResult?.reportExtendedMetadata?.groupingColumnInfo;
                var detailColumnInfo = component?.data?.reportResult?.reportExtendedMetadata?.detailColumnInfo;
                datasets = [];
                labels = map(component?.properties?.visualizationProperties?.tableColumns, (c) => {
                    let label;
                    switch(c.type) {
                        case 'detail':
                            label = detailColumnInfo?.[c.column]?.label || c.column;
                            var index = component?.data?.reportResult?.reportMetadata?.detailColumns?.findIndex((e) => c.column === e);
                            map(component?.data?.reportResult?.factMap?.["T!T"]?.rows || [], (r, i) => {
                                if(!datasets[i]) { datasets[i] = { key : i, columns : [] }; }
                                datasets[i].columns = [...datasets[i].columns, {
                                    name : c.column, value : r.dataCells[index].label
                                }];
                            });
                            break;
                        case 'grouping':
                            label = groupingColumnInfo?.[c.column]?.label || c.column;
                            map(component?.data?.reportResult?.groupingsDown?.groupings || [], (g, i) => {
                                if(!datasets[i]) { datasets[i] = { key : i, columns : [] }; }
                                datasets[i].columns = [...datasets[i].columns, {
                                    name : c.column, value : g.label
                                }];
                            });
                            break;
                        case 'aggregate':
                            label = aggregateColumnInfo?.[c.column]?.label || c.column;
                            var index = component?.data?.reportResult?.reportMetadata?.aggregates?.findIndex((e) => c.column === e), i = 0;
                            map(component?.data?.reportResult?.factMap || [], (r, k) => {
                                if(k !== 'T!T') {
                                    const row = component.data.reportResult.factMap[k];
                                    if(!datasets[i]) { datasets[i] = { key : i, columns : [] }; }
                                    datasets[i].columns = [...datasets[i].columns, {
                                        name : c.column, value : row.aggregates[index].label
                                    }];
                                    i++;
                                }
                            });
                            break;
                    }
                    return { name : c.column, label : label, type: c.type };
                });
                break;
            case 'funnel':
                datasets = [], labels = [''];
                for(let i = 0, len = groupingsDown?.groupings?.length || 0; i < len; i++) {
                    const c = groupingsDown.groupings[i];
                    datasets = [...datasets, {
                        data : [factMap[c.key + '!T'].aggregates[0].value],
                        backgroundColor: this.getColor(theme, i),
                        label: c.label
                    }];
                }
                break;
            case 'scatter':
                var dataMap = {}, i = 0, multipleLayers = false;
                for(let i = 0, len = groupingsDown?.groupings?.length || 0; i < len; i++) {
                    if(groupingsDown.groupings[i].groupings?.length > 0) { multipleLayers = true; break; }
                }
                for(let i1 = 0, len1 = groupingsDown?.groupings?.length || 0; i1 < len1; i1++) {
                    const v1 = groupingsDown.groupings[i1];
                    if(multipleLayers) {
                        for(let i2 = 0, len2 = v1.groupings?.length || 0; i2 < len2; i2++) {
                            const v2 = v1.groupings[i2];
                            dataMap[v1.label + ': ' + v2.label] = {
                                data: [{
                                    x : factMap[v2.key + '!T'].aggregates[0].value,
                                    y : factMap[v2.key + '!T'].aggregates[1].value
                                }],
                                backgroundColor : this.getColor(theme, i++),
                                label: v2.label
                            };
                        }
                    } else dataMap[v1.label] = {
                        data: [{
                            x : factMap[v1.key + '!T'].aggregates[0].value,
                            y : factMap[v1.key + '!T'].aggregates[0].value
                        }],
                        backgroundColor : this.getColor(theme, i++),
                        label: v1.label
                    };
                }
                datasets = Object.values(dataMap);
                break;
            default:
                var multipleLayers = false, labelMap = {};
                for(let i = 0, len = groupingsDown?.groupings?.length || 0; i < len; i++) {
                    labelMap[groupingsDown.groupings[i].label] = null;
                    multipleLayers = groupingsDown.groupings[i].groupings?.length > 0 || multipleLayers;
                }
                if(!multipleLayers) {
                    let data = []
                    for(let i = 0, len = groupingsDown?.groupings?.length || 0; i < len; i++) {
                        data = [...data, factMap[groupingsDown.groupings[i].key + '!T'].aggregates[0].value];
                    }
                    datasets = [{ data: data, backgroundColor: this.getColor(theme), label: '' }];
                }
                else {
                    let dataMap = {};
                    for(let i1 = 0, len1 = groupingsDown?.groupings?.length || 0; i1 < len1; i1++) {
                        const v1 = groupingsDown.groupings[i1];
                        for(let i2 = 0, len2 = v1.groupings?.length || 0; i2 < len2; i2++) {
                            const v2 = v1.groupings[i2];
                            if(!dataMap[v2.label]) { dataMap[v2.label] = { data: clone(labelMap), label: v2.label }; }
                            dataMap[v2.label].data[v1.label] = factMap[v2.key + '!T'].aggregates[0].value;                            
                        }
                    }
                    datasets = map(Object.values(dataMap), (c, i) => (
                        c.data = Object.values(c.data), c.backgroundColor = this.getColor(theme, i), c
                    ));
                }
                labels = Object.keys(labelMap);
                break;
        }
        return { type, datasets, labels };
    }

    buildChart(component, datasets, labels) {
        const container = this.template.querySelector('.container');
        if(container == null) { return setTimeout(() => this.buildChart(component, datasets, labels), 250); }
        const total = abbreviate(component?.data?.reportResult?.factMap?.['T!T']?.aggregates?.[0]?.label) || 0;
        const aggregateInfo = component?.data?.reportResult?.reportExtendedMetadata?.aggregateColumnInfo;
        const groupingInfo = component?.data?.reportResult?.reportExtendedMetadata?.groupingInfo;
        const aggregates = component?.properties?.aggregates;
        const xLabel = aggregates?.length > 1 ? aggregateInfo?.[aggregates?.[0]?.name]?.label : groupingInfo?.[Object.keys(groupingInfo || {})?.[0] || 0]?.label;
        const yLabel = aggregates?.length > 1 ? aggregateInfo?.[aggregates?.[1]?.name]?.label : aggregateInfo?.[aggregates?.[0]?.name]?.label;
        //
        const ctx = container.getContext('2d');
        Chart.register(...registerables);
        this._component = new Chart(ctx, {
            type : this.type === 'funnel' || this.type === 'column' ? 'bar' : this.type,
            data : { datasets, labels },
            options : {
                maintainAspectRatio: false, indexAxis: this.type === 'bar' ? 'y' : 'x',
                plugins : {
                    title : {
                        display: ['doughnut', 'funnel'].includes(this.type),
                        text: yLabel != null ? (yLabel + ': ' + total) : '',
                        color: component.chartTheme === 'dark' ? 'white' : null
                    },
                    legend : {
                        title: {
                            display: ['doughnut', 'funnel'].includes(this.type), text: groupingInfo || '',
                            color: component.chartTheme === 'dark' ? 'white' : null
                        },
                        labels: { color: component.chartTheme === 'dark' ? 'white' : null },
                        position : component?.properties?.visualizationProperties?.legendPosition?.toLowerCase() || 'right'
                    }
                },
                scales: {
                    x: {
                        grid: {
                            display: ['bar', 'scatter'].includes(this.type), drawBorder: false, 
                            color: component.chartTheme === 'dark' ? 'rgba(255, 255, 255, 0.2)' : 'rgba(0, 0, 0, 0.1)'
                        },
                        ticks: {
                            display: ['bar', 'column', 'line', 'scatter'].includes(this.type),
                            color: component.chartTheme === 'dark' ? 'white' : null,
                            callback: function(value) { return abbreviate(this.getLabelForValue(value)); }
                        },
                        title : {
                            display: ['bar', 'column', 'line', 'scatter'].includes(this.type),
                            text: this.type === 'bar' ? (yLabel || '') : (xLabel || ''),
                            color: component.chartTheme === 'dark' ? 'white' : null
                        },
                        stacked: component?.properties?.visualizationProperties?.groupByType === 'stacked' || this.type === 'funnel'
                    },
                    y: {
                        grid: {
                            display: ['column', 'line', 'scatter'].includes(this.type), drawBorder: false, 
                            color: component.chartTheme === 'dark' ? 'rgba(255, 255, 255, 0.2)' : 'rgba(0, 0, 0, 0.1)'
                        },
                        ticks: {
                            display: ['bar', 'column', 'line', 'scatter'].includes(this.type),
                            color: component.chartTheme === 'dark' ? 'white' : null,
                            callback: function(value) { return abbreviate(this.getLabelForValue(value)); }
                        },
                        title : {
                            display: ['bar', 'column', 'line', 'scatter'].includes(this.type),
                            text: this.type === 'bar' ? (xLabel || '') : (yLabel || ''),
                            color: component.chartTheme === 'dark' ? 'white' : null
                        },
                        stacked: component?.properties?.visualizationProperties?.groupByType === 'stacked' || this.type === 'funnel'
                    }
                }
            }
        });
    }

    getColor(theme, index) {
        const themeColors = COLORS[theme || 'light'];
        if(index == null) { return themeColors; }
        const len = themeColors?.length || 0;
        return themeColors[(index % len + len) % len];
    }
}