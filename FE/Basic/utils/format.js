const formatNumber = (value) => {
    if (value === 0) {
        return {
            num: 0,
            unit: '',
            text: '0',
            decimals: 0
        };
    }
    if (value == null || value == '') {
        return {
            num: '-',
            unit: '',
            text: '-',
            decimals: 0
        };
    }
    if (value < 0) {
        value = -value;
    }

    if (value < 10000) {
        return {
            num: value,
            unit: '',
            text: value,
            decimals: 0
        };
    }
    if (value < 100000000) {
        const num = (value / 10000).toFixed(1);
        return {
            num,
            unit: '万',
            text: `${num}万`,
            decimals: 1,
        };
    }
    if (value >= 100000000) {
        const num = (value / 100000000).toFixed(2);
        return {
            num,
            unit: '亿',
            text: `${num}亿`,
            decimals: 2
        };
    }
};
const formatPercent = (value, length = 0) => {
    if (value == null) return '-';
    value = ((value > 0 ? value : -value) * 100).toFixed(length);
    return +value == 0 ? '-' : `${value}%`;
};

// 将分钟：610 转换成 10小时10分钟
const formatMinutes = (time) => {
    if (!time) return '-';
    let hours = Math.floor(time / 60) || '';
    let minutes = time - hours * 60 || '';
    return {
        hours,
        minutes,
        text: `${hours ? `${hours}小时` : ''}${minutes ? `${minutes}分钟` : ''}`
    };
};

export default {
    formatNumber,
    formatPercent,
    formatMinutes
};