import request from '@/utils/request'

// 查询快递站点列表
export function listStation(query) {
    return request({
        url: '/take/station/list',
        method: 'get',
        params: query
    })
}

// 获取快递站点详细信息
export function getStation(stationId) {
    return request({
        url: '/take/station/' + stationId,
        method: 'get'
    })
}

// 新增快递站点
export function addStation(data) {
    return request({
        url: '/take/station',
        method: 'post',
        data: data
    })
}

// 修改快递站点
export function updateStation(data) {
    return request({
        url: '/take/station',
        method: 'put',
        data: data
    })
}

// 删除快递站点
export function deleteStation(stationId) {
    return request({
        url: '/take/station/' + stationId,
        method: 'delete'
    })
}
