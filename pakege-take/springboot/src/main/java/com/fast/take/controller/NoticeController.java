package com.fast.take.controller;

import java.util.List;

import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.fast.system.controller.BaseController;
import com.fast.system.domain.AjaxResult;

import com.fast.take.domain.Notice;
import com.fast.take.service.INoticeService;
import com.fast.system.domain.TableDataInfo;

/**
 * 通知公告Controller
 *
 * @author fast
 * @date 2026-01-06
 */
@RestController
@RequestMapping("/take/notice")
public class NoticeController extends BaseController {
    @Resource
    private INoticeService noticeService;

    /**
     * 查询通知公告列表
     */
    @GetMapping("/list")
    public TableDataInfo list(Notice notice) {
        startPage();
        List<Notice> list = noticeService.selectNoticeList(notice);
        return getDataTable(list);
    }

    /**
     * 获取通知公告详细信息
     */
    @GetMapping(value = "/{noticeId}")
    public AjaxResult getInfo(@PathVariable("noticeId") String noticeId) {
        return success(noticeService.selectNoticeByNoticeId(noticeId));
    }

    /**
     * 新增通知公告
     */
    @PostMapping
    public AjaxResult add(@RequestBody Notice notice) {
        return toAjax(noticeService.insertNotice(notice));
    }

    /**
     * 修改通知公告
     */
    @PutMapping
    public AjaxResult edit(@RequestBody Notice notice) {
        return toAjax(noticeService.updateNotice(notice));
    }

    /**
     * 删除通知公告
     */
    @DeleteMapping("/{noticeIds}")
    public AjaxResult remove(@PathVariable String[] noticeIds) {
        return toAjax(noticeService.deleteNoticeByNoticeIds(noticeIds));
    }
}
