package com.fast.take.domain;

import lombok.Data;

/**
 * 快递站点对象 station
 */
@Data
public class Station {
    //站点ID
    private String stationId;
    //分类名称
    private String name;
    //排序
    private Integer sort;
}
