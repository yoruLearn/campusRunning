package com.fast.take.service.impl;

import com.fast.take.domain.Station;
import com.fast.take.mapper.StationMapper;
import com.fast.take.service.IStationService;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

/**
 * 快递站点 Service业务层
 */
@Service
public class StationServiceImpl implements IStationService {
    @Resource
    private StationMapper stationMapper;

    /**
     * 查询快递站点列表
     * @param station 快递站点对象(查询参数)
     * @return 快递站点列表
     */
    @Override
    public List<Station> selectStationList(Station station) {
        return stationMapper.selectStationList(station);
    }

    /**
     * 获取快递站点详细信息
     * @param stationId 站点主键
     * @return 快递站点详细信息
     */
    @Override
    public Station selectStationByStationId(String stationId) {
        return stationMapper.selectStationByStationId(stationId);
    }

    /**
     * 新增快递站点
     * @param station 表单参数
     * @return 是否新增成功
     */
    @Override
    public int insertStation(Station station) {
        //生成一个UUID 并插入至对象中
        station.setStationId(String.valueOf(UUID.randomUUID()));
        return stationMapper.insertStation(station);
    }

    /**
     * 修改快递站点
     * @param station 表单参数
     * @return 是否修改成功
     */
    @Override
    public int updateStation(Station station) {
        return stationMapper.updateStation(station);
    }

    /**
     * 删除快递站点
     * @param stationIds 需要删除的快递站点主键集合
     * @return 是否删除成功
     */
    @Override
    public int deleteStation(String[] stationIds) {
        return stationMapper.deleteStation(stationIds);
    }
}
