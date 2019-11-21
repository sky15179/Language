import queryString from 'query-string';
const {
    utm_source
} = queryString.parse(window.location.search);

export default () => {
    return new Promise((resolve, reject) => {
        if (utm_source === 'friday') {
            // 当页面内嵌在Friday中时，modal的位置需要重新处理
            const handleParentScrollTop = e => {
                if (e.data.type === 'receiveScrollTop') {
                    const maxTop = document.body.offsetHeight - 680;
                    const parentScrollTop = Math.min(e.data.scrollTop - 350, maxTop);
                    resolve(parentScrollTop);
                }
                window.removeEventListener('message', handleParentScrollTop, false);
            }
            window.addEventListener('message', handleParentScrollTop, false);
            window.parent.postMessage({
                type: 'getScrollTop'
            }, '*');
        } else {
            resolve();
        }
    });
};