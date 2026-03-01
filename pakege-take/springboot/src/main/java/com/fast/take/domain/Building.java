package com.fast.take.domain;

import lombok.*;
import com.fasterxml.jackson.annotation.JsonFormat;
import java.util.Date;

/**
 * 宿舍楼对象 building
 *
 * @author fast
 * @date 2025-12-30
 */

@Data
public class Building
{

    /** 宿舍楼ID */
    private String buildingId;

    /** 宿舍楼名称 */
    private String name;

    /** 排序 */
    private Integer sort;


}
