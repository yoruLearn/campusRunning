package com.fast.take.domain.vo;

import lombok.Data;

import java.util.List;

/**
 * 订单趋势统计VO
 */
@Data
public class OrderTrendVO {
    //日期列表
    private List<String> dates;
    //订单数量列表
    private List<Integer> counts;
}
